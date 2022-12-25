import { useBackend } from '../backend';
import { Button, Flex, Knob, LabeledList, Section } from '../components';
import { Window } from '../layouts';

function getActionType(input){
  if(input == 0)
    return "Storing";
  if(input == 1)
    return "Smelting";
  if(input == 2)
    return "Alloying";
  if(input == 3)
    return "Compressing";
}

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
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Flex
          frex-wrap = "wrap"
          >
        <Flex.Item>
        <Button
          content={running ? "TURN OFF" : "TURN ON"}
          onClick={() =>
            act('set_running')
          }>
        </Button>
        Melting Rate
        <br></br>
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
          }>
        </Knob>
        </Flex.Item>
        <Flex.Item>
        <Section title="Loaded Materials">
         <LabeledList>
          {materials_data.map(material => (
            <LabeledList.Item
              key={material.name}
              label={material.name}
              buttons = {
                <Button
                key={material.name}
                content={material.current_action_string}
                onClick={() =>
                  act('set_smelting', {
                    id: material.id,
                    action_type: material.current_action + 1,
                  })}>
                </Button>
              }>
            </LabeledList.Item>
          ))}
          </LabeledList>
        </Section>
        <Section title="Alloy Menu">
         <LabeledList>
          {alloy_data.map(alloy => (
            <LabeledList.Item
              key={alloy.name}
              label={alloy.name}
              buttons = {
              <Button
                    key={alloy.name}
                    content={alloy.name}
                    selected = {alloy.name == currently_alloying}
                    onClick={() =>
                      act('set_alloying', {
                        id: alloy.name,
                      })
                    }>
                </Button>}>
            </LabeledList.Item>
          ))}
          </LabeledList>
        </Section>
        </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
