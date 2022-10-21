import { sortBy } from 'common/collections';
import { capitalize } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { Blink, Box, Button, Dimmer, Flex, Icon, Modal, Section, TextArea } from '../components';
import { StatusDisplayControls } from './common/StatusDisplayControls';
import { Window } from '../layouts';
import { sanitizeText } from '../sanitize';

const STATE_BUYING_SHUTTLE = 'buying_shuttle';
const STATE_CHANGING_STATUS = 'changing_status';
const STATE_MAIN = 'main';
const STATE_MESSAGES = 'messages';

// Used for whether or not you need to swipe to confirm an alert level change
const SWIPE_NEEDED = 'SWIPE_NEEDED';

const EMAG_SHUTTLE_NOTICE =
  'This shuttle is deemed significantly dangerous to the crew, and is only supplied by the Syndicate.';

const sortShuttles = sortBy(
  (shuttle) => !shuttle.emagOnly,
  (shuttle) => shuttle.creditCost
);

const AlertButton = (props, context) => {
  const { act, data } = useBackend(context);
  const { alertLevelTick, canSetAlertLevel } = data;
  const { alertLevel, setShowAlertLevelConfirm } = props;

  const thisIsCurrent = data.alertLevel === alertLevel;

  return (
    <Button
      icon="exclamation-triangle"
      color={thisIsCurrent && 'good'}
      content={capitalize(alertLevel)}
      onClick={() => {
        if (thisIsCurrent) {
          return;
        }

        if (canSetAlertLevel === SWIPE_NEEDED) {
          setShowAlertLevelConfirm([alertLevel, alertLevelTick]);
        } else {
          act('changeSecurityLevel', {
            newSecurityLevel: alertLevel,
          });
        }
      }}
    />
  );
};

const MessageModal = (props, context) => {
  const { data } = useBackend(context);
  const { maxMessageLength } = data;

  const [input, setInput] = useLocalState(context, props.label, '');

  const longEnough =
    props.minLength === undefined || input.length >= props.minLength;

  return (
    <Modal>
      <Flex direction="column">
        <Flex.Item fontSize="16px" maxWidth="90vw" mb={1}>
          {props.label}:
        </Flex.Item>

        <Flex.Item mr={2} mb={1}>
          <TextArea
            fluid
            height="20vh"
            width="80vw"
            backgroundColor="black"
            textColor="white"
            onInput={(_, value) => {
              setInput(value.substring(0, maxMessageLength));
            }}
            value={input}
          />
        </Flex.Item>

        <Flex.Item>
          <Button
            icon={props.icon}
            content={props.buttonText}
            color="good"
            disabled={!longEnough}
            tooltip={!longEnough ? 'You need a longer reason.' : ''}
            tooltipPosition="right"
            onClick={() => {
              if (longEnough) {
                setInput('');
                props.onSubmit(input);
              }
            }}
          />

          <Button
            icon="times"
            content="Cancel"
            color="bad"
            onClick={props.onBack}
          />
        </Flex.Item>

        {!!props.notice && (
          <Flex.Item maxWidth="90vw">{props.notice}</Flex.Item>
        )}
      </Flex>
    </Modal>
  );
};

const NoConnectionModal = () => {
  return (
    <Dimmer>
      <Flex direction="column" textAlign="center" width="300px">
        <Flex.Item>
          <Icon color="red" name="wifi" size={10} />

          <Blink>
            <div
              style={{
                background: '#db2828',
                bottom: '60%',
                left: '25%',
                height: '10px',
                position: 'relative',
                transform: 'rotate(45deg)',
                width: '150px',
              }}
            />
          </Blink>
        </Flex.Item>

        <Flex.Item fontSize="16px">
          A connection to the station cannot be established.
        </Flex.Item>
      </Flex>
    </Dimmer>
  );
};

const PageBuyingShuttle = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Box>
      <Section>
        <Button
          icon="chevron-left"
          content="Back"
          onClick={() => act('setState', { state: STATE_MAIN })}
        />
      </Section>

      <Section>
        Budget: <b>{data.budget.toLocaleString()}</b> credits
      </Section>

      {sortShuttles(data.shuttles).map((shuttle) => (
        <Section
          title={
            <span
              style={{
                display: 'inline-block',
                width: '70%',
              }}>
              {shuttle.name}
            </span>
          }
          key={shuttle.ref}
          buttons={
            <Button
              content={`${shuttle.creditCost.toLocaleString()} credits`}
              color={shuttle.emagOnly ? 'red' : 'default'}
              disabled={data.budget < shuttle.creditCost}
              onClick={() =>
                act('purchaseShuttle', {
                  shuttle: shuttle.ref,
                })
              }
              tooltip={
                data.budget < shuttle.creditCost
                  ? `You need ${shuttle.creditCost - data.budget} more credits.`
                  : shuttle.emagOnly
                    ? EMAG_SHUTTLE_NOTICE
                    : undefined
              }
              tooltipPosition="left"
            />
          }>
          <Box>{shuttle.description}</Box>
          {shuttle.prerequisites ? (
            <b>Prerequisites: {shuttle.prerequisites}</b>
          ) : null}
        </Section>
      ))}
    </Box>
  );
};

const PageChangingStatus = (props, context) => {
  const { act } = useBackend(context);

  return (
    <Box>
      <Section>
        <Button
          icon="chevron-left"
          content="Back"
          onClick={() => act('setState', { state: STATE_MAIN })}
        />
      </Section>

      <StatusDisplayControls />
    </Box>
  );
};

const PageMain = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    alertLevel,
    alertLevelTick,
    aprilFools,
    callShuttleReasonMinLength,
    canBuyShuttles,
    canMakeAnnouncement,
    canMessageAssociates,
    canRecallShuttles,
    canRequestNuke,
    canSendToSectors,
    canSetAlertLevel,
    canToggleEmergencyAccess,
    emagged,
    syndicate,
    emergencyAccess,
    importantActionReady,
    sectors,
    shuttleCalled,
    shuttleCalledPreviously,
    shuttleCanEvacOrFailReason,
    shuttleLastCalled,
    shuttleRecallable,
  } = data;

  const [callingShuttle, setCallingShuttle] = useLocalState(
    context,
    'calling_shuttle',
    false
  );
  const [messagingAssociates, setMessagingAssociates] = useLocalState(
    context,
    'messaging_associates',
    false
  );
  const [messagingSector, setMessagingSector] = useLocalState(
    context,
    'messaing_sector',
    null
  );
  const [requestingNukeCodes, setRequestingNukeCodes] = useLocalState(
    context,
    'requesting_nuke_codes',
    false
  );

  const [
    [showAlertLevelConfirm, confirmingAlertLevelTick],
    setShowAlertLevelConfirm,
  ] = useLocalState(context, 'showConfirmPrompt', [null, null]);

  return (
    <Box>
      {!syndicate && (
        <Section title="Emergency Shuttle">
          {(!!shuttleCalled && (
            <Button.Confirm
              icon="space-shuttle"
              content="Recall Emergency Shuttle"
              color="bad"
              disabled={!canRecallShuttles || !shuttleRecallable}
              tooltip={
                (canRecallShuttles &&
                  !shuttleRecallable &&
                  "It's too late for the emergency shuttle to be recalled.") ||
                'You do not have permission to recall the emergency shuttle.'
              }
              tooltipPosition="bottom-end"
              onClick={() => act('recallShuttle')}
            />
          )) || (
            <Button
              icon="space-shuttle"
              content="Call Emergency Shuttle"
              disabled={shuttleCanEvacOrFailReason !== 1}
              tooltip={
                shuttleCanEvacOrFailReason !== 1
                  ? shuttleCanEvacOrFailReason
                  : undefined
              }
              tooltipPosition="bottom-end"
              onClick={() => setCallingShuttle(true)}
            />
          )}
          {!!shuttleCalledPreviously &&
            ((shuttleLastCalled && (
              <Box>
                Most recent shuttle call/recall traced to:{' '}
                <b>{shuttleLastCalled}</b>
              </Box>
            )) || (
              <Box>Unable to trace most recent shuttle/recall signal.</Box>
            ))}
        </Section>
      )}

      {!!canSetAlertLevel && (
        <Section title="Alert Level">
          <Flex justify="space-between">
            <Flex.Item>
              <Box>
                Currently on <b>{capitalize(alertLevel)}</b> Alert
              </Box>
            </Flex.Item>

            <Flex.Item>
              <AlertButton
                alertLevel="green"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />

              <AlertButton
                alertLevel="blue"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />
            </Flex.Item>
          </Flex>
        </Section>
      )}

      <Section title="Functions">
        <Flex direction="column">
          {!!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              content="Make Priority Announcement"
              onClick={() => act('makePriorityAnnouncement')}
            />
          )}

          {!!aprilFools && !!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              content="Call Emergency Meeting"
              onClick={() => act('emergency_meeting')}
            />
          )}

          {!!canToggleEmergencyAccess && (
            <Button.Confirm
              icon="id-card-o"
              content={`${
                emergencyAccess ? 'Disable' : 'Enable'
              } Emergency Maintenance Access`}
              color={emergencyAccess ? 'bad' : undefined}
              onClick={() => act('toggleEmergencyAccess')}
            />
          )}

          {!syndicate && (
            <Button
              icon="desktop"
              content="Set Status Display"
              onClick={() => act('setState', { state: STATE_CHANGING_STATUS })}
            />
          )}

          <Button
            icon="envelope-o"
            content="Message List"
            onClick={() => act('setState', { state: STATE_MESSAGES })}
          />

          {canBuyShuttles !== 0 && (
            <Button
              icon="shopping-cart"
              content="Purchase Shuttle"
              disabled={canBuyShuttles !== 1}
              // canBuyShuttles is a string detailing the fail reason
              // if one can be given
              tooltip={canBuyShuttles !== 1 ? canBuyShuttles : undefined}
              tooltipPosition="right"
              onClick={() => act('setState', { state: STATE_BUYING_SHUTTLE })}
            />
          )}

          {!!canMessageAssociates && (
            <Button
              icon="comment-o"
              content={`Send message to ${emagged ? '[UNKNOWN]' : 'CentCom'}`}
              disabled={!importantActionReady}
              onClick={() => setMessagingAssociates(true)}
            />
          )}

          {!!canRequestNuke && (
            <Button
              icon="radiation"
              content="Request Nuclear Authentication Codes"
              disabled={!importantActionReady}
              onClick={() => setRequestingNukeCodes(true)}
            />
          )}

          {!!emagged && !syndicate && (
            <Button
              icon="undo"
              content="Restore Backup Routing Data"
              onClick={() => act('restoreBackupRoutingData')}
            />
          )}
        </Flex>
      </Section>

      {!!canMessageAssociates && messagingAssociates && (
        <MessageModal
          label={`Message to transmit to ${
            emagged ? '[ABNORMAL ROUTING COORDINATES]' : 'CentCom'
          } via quantum entanglement`}
          notice="Please be aware that this process is very expensive, and abuse will lead to...termination. Transmission does not guarantee a response."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingAssociates(false)}
          onSubmit={(message) => {
            setMessagingAssociates(false);
            act('messageAssociates', {
              message,
            });
          }}
        />
      )}

      {!!canRequestNuke && requestingNukeCodes && (
        <MessageModal
          label="Reason for requesting nuclear self-destruct codes"
          notice="Misuse of the nuclear request system will not be tolerated under any circumstances. Transmission does not guarantee a response."
          icon="bomb"
          buttonText="Request Codes"
          onBack={() => setRequestingNukeCodes(false)}
          onSubmit={(reason) => {
            setRequestingNukeCodes(false);
            act('requestNukeCodes', {
              reason,
            });
          }}
        />
      )}

      {!!callingShuttle && (
        <MessageModal
          label="Nature of emergency"
          icon="space-shuttle"
          buttonText="Call Shuttle"
          minLength={callShuttleReasonMinLength}
          onBack={() => setCallingShuttle(false)}
          onSubmit={(reason) => {
            setCallingShuttle(false);
            act('callShuttle', {
              reason,
            });
          }}
        />
      )}

      {!!canSetAlertLevel &&
        showAlertLevelConfirm &&
        confirmingAlertLevelTick === alertLevelTick && (
          <Modal>
            <Flex direction="column" textAlign="center" width="300px">
              <Flex.Item fontSize="16px" mb={2}>
                Swipe ID to confirm change
              </Flex.Item>

              <Flex.Item mr={2} mb={1}>
                <Button
                  icon="id-card-o"
                  content="Swipe ID"
                  color="good"
                  fontSize="16px"
                  onClick={() =>
                    act('changeSecurityLevel', {
                      newSecurityLevel: showAlertLevelConfirm,
                    })
                  }
                />

                <Button
                  icon="times"
                  content="Cancel"
                  color="bad"
                  fontSize="16px"
                  onClick={() => setShowAlertLevelConfirm(false)}
                />
              </Flex.Item>
            </Flex>
          </Modal>
        )}

      {!!canSendToSectors && sectors.length > 0 && (
        <Section title="Allied Sectors">
          <Flex direction="column">
            {sectors.map((sectorName) => (
              <Flex.Item key={sectorName}>
                <Button
                  content={`Send a message to station in ${sectorName} sector`}
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector(sectorName)}
                />
              </Flex.Item>
            ))}

            {sectors.length > 2 && (
              <Flex.Item>
                <Button
                  content="Send a message to all allied stations"
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector('all')}
                />
              </Flex.Item>
            )}
          </Flex>
        </Section>
      )}

      {!!canSendToSectors && sectors.length > 0 && messagingSector && (
        <MessageModal
          label="Message to send to allied station"
          notice="Please be aware that this process is very expensive, and abuse will lead to...termination."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingSector(null)}
          onSubmit={(message) => {
            act('sendToOtherSector', {
              destination: messagingSector,
              message,
            });

            setMessagingSector(null);
          }}
        />
      )}
    </Box>
  );
};

const PageMessages = (props, context) => {
  const { act, data } = useBackend(context);
  const messages = data.messages || [];

  const children = [];

  children.push(
    <Section>
      <Button
        icon="chevron-left"
        content="Back"
        onClick={() => act('setState', { state: STATE_MAIN })}
      />
    </Section>
  );

  const messageElements = [];

  for (const [messageIndex, message] of Object.entries(messages)) {
    let answers = null;

    if (message.possibleAnswers.length > 0) {
      answers = (
        <Box mt={1}>
          {message.possibleAnswers.map((answer, answerIndex) => (
            <Button
              content={answer}
              color={message.answered === answerIndex + 1 ? 'good' : undefined}
              key={answerIndex}
              onClick={
                message.answered
                  ? undefined
                  : () =>
                    act('answerMessage', {
                      message: parseInt(messageIndex, 10) + 1,
                      answer: answerIndex + 1,
                    })
              }
            />
          ))}
        </Box>
      );
    }

    const textHtml = {
      __html: sanitizeText(message.content),
    };

    messageElements.push(
      <Section
        title={message.title}
        key={messageIndex}
        buttons={
          <Button.Confirm
            icon="trash"
            content="Delete"
            color="red"
            onClick={() =>
              act('deleteMessage', {
                message: messageIndex + 1,
              })
            }
          />
        }>
        <Box dangerouslySetInnerHTML={textHtml} />

        {answers}
      </Section>
    );
  }

  children.push(messageElements.reverse());

  return children;
};

export const CommunicationsConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    authenticated,
    authorizeName,
    canLogOut,
    emagged,
    hasConnection,
    page,
    canRequestSafeCode,
    safeCodeDeliveryWait,
    safeCodeDeliveryArea,
  } = data;

  return (
    <Window width={400} height={650} theme={emagged ? 'syndicate' : undefined}>
      <Window.Content scrollable>
        {!hasConnection && <NoConnectionModal />}

        {(canLogOut || !authenticated) && (
          <Section title="Authentication">
            <Button
              icon={authenticated ? 'sign-out-alt' : 'sign-in-alt'}
              content={
                authenticated
                  ? `Log Out${authorizeName ? ` (${authorizeName})` : ''}`
                  : 'Log In'
              }
              color={authenticated ? 'bad' : 'good'}
              onClick={() => act('toggleAuthentication')}
            />
          </Section>
        )}

        {(!!canRequestSafeCode && (
          <Section title="Emergency Safe Code">
            <Button
              icon="key"
              content="Request Safe Code"
              color="good"
              onClick={() => act('requestSafeCodes')}
            />
          </Section>
        )) ||
          (!!safeCodeDeliveryWait && (
            <Section title="Emergency Safe Code Delivery">
              {`Drop pod to ${safeCodeDeliveryArea} in \
            ${Math.round(safeCodeDeliveryWait / 10)}s`}
            </Section>
          ))}

        {!!authenticated &&
          ((page === STATE_BUYING_SHUTTLE && <PageBuyingShuttle />) ||
            (page === STATE_CHANGING_STATUS && <PageChangingStatus />) ||
            (page === STATE_MAIN && <PageMain />) ||
            (page === STATE_MESSAGES && <PageMessages />) || (
              <Box>Page not implemented: {page}</Box>
            ))}
      </Window.Content>
    </Window>
  );
};
