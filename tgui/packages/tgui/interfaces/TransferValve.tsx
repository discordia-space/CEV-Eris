import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { Window } from '../layouts';

interface TransferValveData {
  attachmentOne: string;
  attachmentTwo: string;
  attachment: string;
  isOpen: boolean;
}

export const TransferValve = (props: any) => {
  return (
    <Window width={310} height={300}>
      <Window.Content>
        <TransferValveContent />
      </Window.Content>
    </Window>
  );
};

const TransferValveContent = (props: any) => {
  const { act, data } = useBackend<TransferValveData>();
  const { attachmentOne, attachmentTwo, attachment, isOpen } = data;

  return (
    <Stack fill vertical justify="space-between">
      <Stack.Item>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Valve Status">
              <Button
                icon={isOpen ? 'unlock' : 'lock'}
                disabled={!attachmentOne || !attachmentTwo}
                onClick={() => act('toggle')}
              >
                {isOpen ? 'Opened' : 'Closed'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section
          title="Valve Attachment"
          buttons={
            <Button
              icon={'cog'}
              disabled={!attachment}
              onClick={() => act('device')}
            >
              Configure
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Attachment">
              {attachment ? (
                <Button
                  icon={'eject'}
                  disabled={!attachment}
                  onClick={() => act('remove_device')}
                >
                  {attachment}
                </Button>
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
                  disabled={!attachmentOne}
                  onClick={() => act('tankone')}
                >
                  {attachmentOne}
                </Button>
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
                  disabled={!attachmentTwo}
                  onClick={() => act('tanktwo')}
                >
                  {attachmentTwo}
                </Button>
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
