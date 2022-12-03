import { sortBy } from 'common/collections';
import { toTitleCase } from 'common/string';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const PortableChemMixer = (props, context) => {
  const { act, data } = useBackend(context);
  const recording = !!data.recordingRecipe;
  const beakerTransferAmounts = data.beakerTransferAmounts || [];
  const beakerContents =
    (recording &&
      Object.keys(data.recordingRecipe).map((id) => ({
        id,
        name: toTitleCase(id.replace(/_/, ' ')),
        volume: data.recordingRecipe[id],
      }))) ||
    data.beakerContents ||
    [];
  const chemicals = sortBy((chem) => chem.title)(data.chemicals);
  return (
    <Window width={465} height={550}>
      <Window.Content scrollable>
        <Section
          title="Dispense"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="plus"
              selected={amount === data.amount}
              content={amount}
              onClick={() =>
                act('amount', {
                  target: amount,
                })
              }
            />
          ))}>
          <Box>
            {chemicals.map((chemical) => (
              <Button
                key={chemical.id}
                icon="tint"
                fluid
                lineHeight={1.75}
                content={`(${chemical.volume}) ${chemical.title}`}
                tooltip={'pH: ' + chemical.pH}
                onClick={() =>
                  act('dispense', {
                    reagent: chemical.id,
                  })
                }
              />
            ))}
          </Box>
        </Section>
        <Section
          title="Disposal controls"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="minus"
              disabled={recording}
              content={amount}
              onClick={() => act('remove', { amount })}
            />
          ))}>
          <LabeledList>
            <LabeledList.Item
              label="Beaker"
              buttons={
                !!data.isBeakerLoaded && (
                  <Button
                    icon="eject"
                    content="Eject"
                    disabled={!data.isBeakerLoaded}
                    onClick={() => act('eject')}
                  />
                )
              }>
              {(recording && 'Virtual beaker') ||
                (data.isBeakerLoaded && (
                  <>
                    <AnimatedNumber
                      initial={0}
                      value={data.beakerCurrentVolume}
                    />
                    /{data.beakerMaxVolume} units
                  </>
                )) ||
                'No beaker'}
            </LabeledList.Item>
            <LabeledList.Item label="Contents">
              <Box color="label">
                {(!data.isBeakerLoaded && !recording && 'N/A') ||
                  (beakerContents.length === 0 && 'Nothing')}
              </Box>
              {beakerContents.map((chemical) => (
                <Box key={chemical.name} color="label">
                  <AnimatedNumber initial={0} value={chemical.volume} /> units
                  of {chemical.name}
                </Box>
              ))}
              {beakerContents.length > 0 && !!data.showpH && (
                <Box>
                  pH:
                  <AnimatedNumber value={data.beakerCurrentpH} />
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
