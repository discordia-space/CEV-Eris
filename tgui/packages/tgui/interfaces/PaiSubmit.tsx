import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, Section, Stack } from '../components';
import { Window } from '../layouts';
import { logger } from '../logging';

type Data = {
  comments: string;
  description: string;
  name: string;
};

const PAI_DESCRIPTION = `Personal AIs are advanced models capable of nuanced
interaction. They are designed to assist their masters in their work. They
do not possess hands, thus they cannot interact with equipment or items. While
in hologram form, you cannot be directly killed, but you may be incapacitated.`;

const PAI_RULES = `You are expected to role play to some degree. Keep in mind:
Not entering information may lead to you not being selected. Press submit to
alert pAI cards of your candidacy.`;

export const PaiSubmit = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { comments, description, name } = data;
  const [input, setInput] = useLocalState<Data>(context, 'input', {
    comments,
    description,
    name,
  });
  logger.log(input);

  return (
    <Window width={400} height={460} title="pAI Candidacy Menu">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <DetailsDisplay />
          </Stack.Item>
          <Stack.Item>
            <InputDisplay input={input} setInput={setInput} />
          </Stack.Item>
          <Stack.Item>
            <ButtonsDisplay input={input} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Displays basic info about playing pAI */
const DetailsDisplay = (props, context) => {
  return (
    <Section fill scrollable title="Details">
      <Box color="label">
        {PAI_DESCRIPTION}
        <br />
        <br />
        {PAI_RULES}
      </Box>
    </Section>
  );
};

/** Input boxes for submission details */
const InputDisplay = (props, context) => {
  const { input, setInput } = props;
  const { name, description, comments } = input;

  return (
    <Section fill title="Input">
      <Stack fill vertical>
        <Stack.Item>
          <Box bold color="label">
            Name
          </Box>
          <Input
            fluid
            maxLength={41}
            value={name}
            onChange={(e, value) => setInput({ ...input, name: value })}
          />
        </Stack.Item>
        <Stack.Item>
          <Box bold color="label">
            Description
          </Box>
          <Input
            fluid
            maxLength={100}
            value={description}
            onChange={(e, value) => setInput({ ...input, description: value })}
          />
        </Stack.Item>
        <Stack.Item>
          <Box bold color="label">
            OOC Comments
          </Box>
          <Input
            fluid
            maxLength={100}
            value={comments}
            onChange={(e, value) => setInput({ ...input, comments: value })}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

/** Gives the user a submit button */
const ButtonsDisplay = (props, context) => {
  const { act } = useBackend<Data>(context);
  const { input } = props;
  const { comments, description, name } = input;

  return (
    <Section fill>
      <Stack>
        <Stack.Item>
          <Button
            onClick={() => act('save', { comments, description, name })}
            tooltip="Saves your candidate data locally.">
            SAVE
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() => act('load')}
            tooltip="Loads saved candidate data, if any.">
            LOAD
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('submit', {
                comments,
                description,
                name,
              })
            }>
            SUBMIT
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
