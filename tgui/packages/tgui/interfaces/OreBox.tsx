import { toTitleCase } from 'common/string';
import { Box, Button, NumberInput, Section, Stack } from '../components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type Data = {
  materials: Material[];
};

type Material = {
  type: string;
  name: string;
  amount: number;
};

export const OreBox = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { materials } = data;

  return (
    <Window width={460} height={265}>
      <Window.Content>
        <Section
          fill
          scrollable
          title="Ores"
          buttons={
            <Button
              content="Eject All Ores"
              onClick={() => act('ejectallores')}
            />
          }
        >
          <Stack direction="column">
            <Stack.Item>
              <Section>
                <Stack vertical>
                  <Stack align="start">
                    <Stack.Item basis="30%">
                      <Box bold>Ore</Box>
                    </Stack.Item>
                    <Stack.Item basis="20%">
                      <Section align="center">
                        <Box bold>Amount</Box>
                      </Section>
                    </Stack.Item>
                  </Stack>
                  {materials.map((material) => (
                    <OreRow
                      key={material.type}
                      material={material}
                      onRelease={(type, amount) =>
                        act('eject', {
                          type: type,
                          qty: amount,
                        })
                      }
                      onReleaseAll={(type) =>
                        act('ejectall', {
                          type: type,
                        })
                      }
                    />
                  ))}
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const OreRow = (props, context) => {
  const { material, onRelease, onReleaseAll } = props;

  const [amount, setAmount] = useLocalState(
    context,
    'amount' + material.name,
    1,
  );

  const amountAvailable = Math.floor(material.amount);
  return (
    <Stack.Item>
      <Stack align="center">
        <Stack.Item basis="30%">{toTitleCase(material.name)}</Stack.Item>
        <Stack.Item basis="20%">
          <Section align="center">
            <Box mr={0} color="label" inline>
              {amountAvailable}
            </Box>
          </Section>
        </Stack.Item>
        <Stack.Item basis="50%">
          <NumberInput
            width="32px"
            step={1}
            stepPixelSize={5}
            minValue={1}
            maxValue={100}
            value={amount}
            onChange={(e, value) => setAmount(value)}
          />
          <Button
            content="Eject Amount"
            onClick={() => onRelease(material.type, amount)}
          />
          <Button
            content="Eject All"
            onClick={() => onReleaseAll(material.type)}
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};
