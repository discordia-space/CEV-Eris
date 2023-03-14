import { useBackend } from '../backend';
import { Box, Button, Flex, Knob, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Processor = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    materials_data = [],
    alloy_data = [],
    currently_alloying,
    running,
    sheet_rate,
  } = data;
  if (data.machine) {
    return (
      <Window resizable>
        <Window.Content scrollable>
          <Flex frex-wrap="wrap">
            <Flex.Item>
              <Button
                content={running ? 'TURN OFF' : 'TURN ON'}
                onClick={() => act('set_running')}
              />
              <Box>
                <Knob
                  size={2}
                  minValue={5}
                  maxValue={30}
                  value={5}
                  unit="Sheets"
                  fillValue={sheet_rate}
                  content="Smelting rate"
                  step={1}
                  stepPixelSize={1}
                  onDrag={(e, value) =>
                    act('set_rate', {
                      sheets: value,
                    })
                  }
                />
                <br />
                <center>Melting Rate</center>
              </Box>
            </Flex.Item>
            <Flex.Item>
              <Section title="Loaded Materials">
                <LabeledList>
                  {materials_data.map((material) => (
                    <LabeledList.Item
                      key={material.name}
                      label={material.name}
                      buttons={
                        <Button
                          key={material.name}
                          content={material.current_action_string}
                          onClick={() =>
                            act('set_smelting', {
                              id: material.id,
                              action_type: material.current_action + 1,
                            })
                          }
                        />
                      }>
                      {material.amount}
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              </Section>
              <Section title="Alloy Menu">
                <LabeledList>
                  {alloy_data.map((alloy) => (
                    <LabeledList.Item
                      key={alloy.name}
                      label={alloy.name}
                      buttons={
                        <Button
                          key={alloy.name}
                          content={alloy.name}
                          selected={alloy.name === currently_alloying}
                          onClick={() =>
                            act('set_alloying', {
                              id: alloy.name,
                            })
                          }
                        />
                      }
                    />
                  ))}
                </LabeledList>
              </Section>
            </Flex.Item>
          </Flex>
        </Window.Content>
      </Window>
      // Incase theres no machine
    );
  } else {
    <Window resizable>
      No machine linked! There must be a material processor within 3 tiles for
      the wireless link to connect.
      <Button content="Attempt linking" onClick={() => act('machine_link')} />
    </Window>;
  }
};
