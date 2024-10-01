import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

interface TransferValveData {
  attachmentOne: string;
  attachmentTwo: string;
  attachment: string;
  isOpen: boolean;
}

export const TransferValve = (props: any, context: any) => {
  return (
    <Window width={310} height={300}>
      <Window.Content>
        <TransferValveContent />
      </Window.Content>
    </Window>
  );
};

const TransferValveContent = (props: any, context: any) => {
  const { act, data } = useBackend<TransferValveData>(context);
  const { attachmentOne, attachmentTwo, attachment, isOpen } = data;

  return (
    <Stack fill vertical justify="space-between">
      <Stack.Item>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Valve Status">
              <Button
                icon={isOpen ? 'unlock' : 'lock'}
                content={isOpen ? 'Opened' : 'Closed'}
                disabled={!attachmentOne || !attachmentTwo}
                onClick={() => act('toggle')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section
          title="Valve Attachment"
          buttons={
            <Button
              content="Configure"
              icon={'cog'}
              disabled={!attachment}
              onClick={() => act('device')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Attachment">
              {attachment ? (
                <Button
                  icon={'eject'}
                  content={attachment}
                  disabled={!attachment}
                  onClick={() => act('remove_device')}
                />
              ) : (
                <Box color="average">No Assembly</Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Attachment One">
          <LabeledList>
            <LabeledList.Item label="Attachment">
              {attachmentOne ? (
                <Button
                  icon={'eject'}
                  content={attachmentOne}
                  disabled={!attachmentOne}
                  onClick={() => act('tankone')}
                />
              ) : (
                <Box color="average">No Tank</Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Attachment Two">
          <LabeledList>
            <LabeledList.Item label="Attachment">
              {attachmentTwo ? (
                <Button
                  icon={'eject'}
                  content={attachmentTwo}
                  disabled={!attachmentTwo}
                  onClick={() => act('tanktwo')}
                />
              ) : (
                <Box color="average">No Tank</Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
