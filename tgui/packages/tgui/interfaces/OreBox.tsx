import { toTitleCase } from 'common/string';
import { Box, Button, NumberInput, Section, Table } from '../components';
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

const OREBOX_INFO = `All ores will be placed in here when you are wearing a
mining stachel on your belt or in a pocket while dragging the ore box.`;

export const OreBox = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { materials } = data;

  return (
    <Window width={460} height={415}>
      <Window.Content scrollable>
        <Section
          title="Ores"
          buttons={
            <Button
              content="Eject All Ores"
              onClick={() => act('ejectallores')}
            />
          }>
          <Table>
            <Table.Row header>
              <Table.Cell>Ore</Table.Cell>
              <Table.Cell collapsing textAlign="right">
                Amount
              </Table.Cell>
            </Table.Row>
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
          </Table>
        </Section>
        <Section>
          <Box>{OREBOX_INFO}</Box>
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
    1
  );

  const amountAvailable = Math.floor(material.amount);
  return (
    <Table.Row>
      <Table.Cell>{toTitleCase(material.name)}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Box mr={2} color="label" inline>
          {amountAvailable}
        </Box>
      </Table.Cell>
      <Table.Cell collapsing>
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
      </Table.Cell>
    </Table.Row>
  );
};
