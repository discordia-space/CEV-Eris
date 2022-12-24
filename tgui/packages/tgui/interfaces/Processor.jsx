import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Processor = (props, context) => {
  const { act, data } = useBackend(context);
  // Extract `health` and `color` variables from the `data` object.
  const {
    materials_data = [],
    alloy_data = [],
  } = data;
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Loaded Materials">
         <LabeledList>
          {materials_data.map(material => (
            <LabeledList.Item
              key={material.name}
              label={material.current_action}>
            </LabeledList.Item>
          ))}
          </LabeledList>
        </Section>
        <Section title="Alloy Menu">
         <LabeledList>
          {alloy_data.map(alloy => (
            <LabeledList.Item
              key={alloy.name}
              label={alloy.creating}>
            </LabeledList.Item>
          ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
