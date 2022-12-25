import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
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

  } = data;
  return (
    <Window resizable>
      <Window.Content scrollable>
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
                    id: material.name,
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
      </Window.Content>
    </Window>
  );
};
