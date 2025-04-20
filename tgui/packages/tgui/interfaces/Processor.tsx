import { useBackend } from 'tgui/backend';
import { Box, Button, Knob, LabeledList, Section } from 'tgui-core/components';

import { Window } from '../layouts';

interface ProcessorData {
  machine: string;
  materials_data: {
    id: string;
    name: string;
    current_action: number;
    current_action_string: string;
    amount: number;
  }[];
  alloy_data: {
    name: string;
    id: string;
  }[];
  currently_alloying: string;
  running: boolean;
  sheet_rate: number;
}

export const Processor = (props: any, context: any) => {
  const { act, data } = useBackend<ProcessorData>();
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
      <Window title="Material Processor Control">
        <Window.Content scrollable>
          <Section
            title="Control"
            buttons={
              <Button onClick={() => act('set_running')}>
                {`Turn ${running ? 'Off' : 'On'}`}
              </Button>
            }
          >
            <center>Smelting Rate</center>
            <center>{sheet_rate} Sheets</center>
            <Box>
              <Knob
                size={2}
                minValue={5}
                maxValue={30}
                value={sheet_rate}
                unit="Sheets"
                fillValue={sheet_rate}
                step={1}
                stepPixelSize={5}
                onDrag={(e, value) =>
                  act('set_rate', {
                    sheets: value,
                  })
                }
              />
            </Box>
          </Section>
          <Section title="Loaded Materials">
            <LabeledList>
              {materials_data.map((material) => (
                <LabeledList.Item
                  key={material.name}
                  label={material.name}
                  buttons={
                    <Button
                      key={material.name}
                      onClick={() =>
                        act('set_smelting', {
                          id: material.id,
                          action_type: material.current_action + 1,
                        })
                      }
                    >
                      {material.current_action_string}
                    </Button>
                  }
                >
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
                      selected={alloy.name === currently_alloying}
                      onClick={() =>
                        act('set_alloying', {
                          id: alloy.name,
                        })
                      }
                    >
                      {alloy.name}
                    </Button>
                  }
                />
              ))}
            </LabeledList>
          </Section>
        </Window.Content>
      </Window>
      // Incase theres no machine
    );
  } else {
    <Window>
      No machine linked! There must be a material processor within 3 tiles for
      the wireless link to connect.
      <Button content="Attempt linking" onClick={() => act('machine_link')} />
    </Window>;
  }
};
