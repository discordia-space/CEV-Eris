import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Flex,
  Input,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { Window } from '../layouts';

type Data = {
  announce_to_all_mobs: boolean;
  announcer_sounds: string[];
  command_name: string;
  command_name_presets: string[];
  command_report_content: string;
  sanitize_content: BooleanLike;
  announcement_color: string;
  announcement_colors: string[];
  subheader: string;
  custom_name: string;
  played_sound: string;
  append_update_name: BooleanLike;
};

export const CommandReport = () => {
  return (
    <Window
      title="Create Command Report"
      width={325}
      height={715}
      theme="admin"
    >
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <CentComName />
            <AnnouncementColor />
            <AnnouncementSound />
          </Stack.Item>
          <Stack.Item>
            <SubHeader />
          </Stack.Item>
          <Stack.Item>
            <ReportText />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Allows the user to set the "sender" of the message via dropdown */
const CentComName = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    command_name,
    command_name_presets,
    custom_name,
    append_update_name,
  } = data;

  return (
    <Section title="Set Central Command name" textAlign="center">
      <Dropdown
        width="100%"
        selected={command_name}
        options={command_name_presets}
        onSelected={(value) =>
          act('update_command_name', {
            updated_name: value,
          })
        }
      />
      {!!custom_name && (
        <Input
          width="100%"
          mt={1}
          value={command_name}
          placeholder={command_name}
          onChange={(_, value) =>
            act('update_command_name', {
              updated_name: value,
            })
          }
        />
      )}
      <Button.Checkbox
        mt={1}
        content='Append "Update" to command name'
        checked={append_update_name}
        onClick={() => act('toggle_update_append')}
      />
    </Section>
  );
};

/** Allows the user to set the "subheader" of the message via dropdown */
const SubHeader = (props) => {
  const { act, data } = useBackend<Data>();
  const { subheader } = data;

  return (
    <Section title="Set report subheader" textAlign="center">
      <Box>Keep blank to not include a subheader</Box>
      <Input
        width="100%"
        mt={1}
        value={subheader}
        placeholder={subheader}
        onChange={(_, value) =>
          act('set_subheader', {
            new_subheader: value,
          })
        }
      />
    </Section>
  );
};

/** Features a section with dropdown for the announcement colour. */
const AnnouncementColor = (props) => {
  const { act, data } = useBackend<Data>();
  const { announcement_colors = [], announcement_color } = data;

  return (
    <Section title="Set announcement color" textAlign="center">
      <Dropdown
        width="100%"
        selected={announcement_color}
        options={announcement_colors}
        onSelected={(value) =>
          act('update_announcement_color', {
            updated_announcement_color: value,
          })
        }
      />
    </Section>
  );
};

/** Features a section with dropdown for sounds. */
const AnnouncementSound = (props) => {
  const { act, data } = useBackend<Data>();
  const { announcer_sounds = [], played_sound } = data;

  // We have to do a shitty style hack below because applying props to <Dropdown> doesn't apply it to the root element, and in order for it to have a full width, we have to do this, and this is the only way I could figure it out.
  return (
    <Section title="Set announcement sound" textAlign="center">
      <style>
        {`
      #announcement-sound-container div:last-child {
        width: 100%;
        flex-grow: true;
      }
    `}
      </style>
      <Flex id="announcement-sound-container" direction="row" width="100%" grow>
        <Button
          width="24px"
          height="22px"
          icon="volume-up"
          onClick={() => act('preview_sound')}
          tooltip={
            'Preview sound - Some sounds have variations such as default_alert and default_commandreport, so what you preview here may be different than what is played for the station. Respects volume mixer preferences.'
          }
        />
        <Dropdown
          width="100%"
          selected={played_sound}
          options={announcer_sounds}
          onSelected={(value) =>
            act('set_report_sound', {
              picked_sound: value,
            })
          }
        />
      </Flex>
    </Section>
  );
};

/** Creates the report textarea with a submit button. */
const ReportText = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    announce_to_all_mobs,
    command_report_content,
    sanitize_content,
  } = data;
  const [commandReport, setCommandReport] = useState<string>(command_report_content);

  return (
    <Section
      title="Set report text"
      textAlign="center"
      buttons={
        <Button.Checkbox
          fluid
          checked={sanitize_content}
          onClick={() => act('toggle_sanitization')}
          tooltip={
            "Whether or not to sanitize the contents. Disabling this means you can use custom HTML in your reports. Be careful though, you don't want to get ridiculed for an embed fail :) "
          }
        >
          Sanitize
        </Button.Checkbox>
      }
    >
      <TextArea
        height="200px"
        mb={1}
        onInput={(_, value) => setCommandReport(value)}
        value={commandReport}
      />
      <Stack vertical>
        <Stack.Item>
          <Flex direction="row" width="100%" grow>
            <Button.Checkbox
              fluid
              width="100%"
              checked={announce_to_all_mobs}
              onClick={() => act('toggle_mob_announce')}
              tooltip={
                "Whether or not this should announce to all mobs, or just those in the GLOB.player_list"
              }
            >
              Announce to all mobs
            </Button.Checkbox>
            <Button
              ml="2px"
              width="24px"
              height="20px"
              icon="eye"
              onClick={() =>
                act('submit_report', { report: commandReport, preview: true })
              }
              tooltip={
                'Preview report - Sends the report to only you to preview it.'
              }
            />
          </Flex>
        </Stack.Item>
        <Stack.Item>
          <Button.Confirm
            fluid
            width="100%"
            icon="check"
            textAlign="center"
            content="Submit Report"
            onClick={() => act('submit_report', { report: commandReport })}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
