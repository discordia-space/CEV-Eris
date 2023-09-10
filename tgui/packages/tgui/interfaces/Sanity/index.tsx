import { resolveAsset } from '../../assets';
import { useBackend } from '../../backend';
import { BlockQuote, Box, LabeledList, ProgressBar, Section, Stack } from '../../components';
import { Window } from '../../layouts';
import { TRAIT_ASSET, TRAIT_DESCRIPTION, TRAIT_LABEL, TRAIT_NAME } from './constants';

export const TraitBar = (props: TraitBarProps) => {
  const { maxValue, minValue, value, label } = props;
  const max = maxValue ? maxValue : 100;

  return (
    <LabeledList.Item textAlign="right" label={label}>
      <ProgressBar
        width="55vw"
        value={value}
        minValue={minValue ? minValue : 0}
        maxValue={maxValue ? maxValue : 100}
        ranges={{
          good: [max * 0.6, Infinity],
          average: [max * 0.3, max * 0.6],
          bad: [-Infinity, max * 0.3],
        }}
      />
    </LabeledList.Item>
  );
};

export const TraitFluff = (props: TraitFluffProps) => {
  const { bar, desc } = props;
  return (
    <Stack fill vertical>
      <Stack.Item
        grow
        style={{
          'overflow': 'hidden',
          'white-space': 'wrap',
          'text-overflow': 'ellipsis',
        }}>
        <BlockQuote>{desc}</BlockQuote>
      </Stack.Item>
      <Stack.Item>{bar}</Stack.Item>
    </Stack>
  );
};

export const DesiresTraitFluff = (props: DesiresTraitFluffProps) => {
  const { bar, desc, active, desires } = props;
  return (
    <Stack fill vertical>
      <Stack.Item
        grow
        style={{
          'overflow': 'hidden',
          'white-space': 'wrap',
          'text-overflow': 'ellipsis',
        }}>
        <BlockQuote>{desc}</BlockQuote>
      </Stack.Item>
      <Stack.Item />
      <Stack.Item>
        {active ? (
          <>
            <LabeledList.Item label="Desires">
              {desires.join(', ')}
            </LabeledList.Item>
            {bar}
          </>
        ) : (
          <BlockQuote>{"Currently you don't have desires."}</BlockQuote>
        )}
      </Stack.Item>
    </Stack>
  );
};

export const Trait = (props: TraitProps) => {
  const { fluff, title, img } = props;
  return (
    <Section title={title}>
      <Stack height="100px" fill>
        <Stack.Item shrink>
          <Box as="img" width="100px" src={resolveAsset(img)} />
        </Stack.Item>
        <Stack.Item grow basis={0}>
          {fluff}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const Sanity = (props: any, context: any) => {
  const { data } = useBackend<SanityData>(context);
  const { style, sanity, desires, righteous, insight } = data;

  return (
    <Window width={650} height={righteous.present ? 802 : 650}>
      <Window.Content style={{ 'background-image': 'none' }} scrollable>
        <Stack vertical>
          <Stack.Item>
            <Trait
              fluff={
                <TraitFluff
                  desc={TRAIT_DESCRIPTION.Sanity}
                  bar={
                    <TraitBar
                      maxValue={sanity.max}
                      value={sanity.value}
                      label={TRAIT_LABEL.Sanity}
                    />
                  }
                />
              }
              title={TRAIT_NAME.Sanity}
              img={TRAIT_ASSET.Sanity}
            />
          </Stack.Item>
          <Stack.Item>
            <Trait
              fluff={
                <TraitFluff
                  desc={TRAIT_DESCRIPTION.Insight}
                  bar={<TraitBar value={insight} label={TRAIT_LABEL.Insight} />}
                />
              }
              title={TRAIT_NAME.Insight}
              img={TRAIT_ASSET.Insight}
            />
          </Stack.Item>
          <Stack.Item>
            <Trait
              fluff={
                <TraitFluff
                  desc={TRAIT_DESCRIPTION.Style}
                  bar={
                    <TraitBar
                      maxValue={style.max}
                      minValue={style.min}
                      value={style.value}
                      label={TRAIT_LABEL.Style}
                    />
                  }
                />
              }
              title={TRAIT_NAME.Style}
              img={TRAIT_ASSET.Style}
            />
          </Stack.Item>
          <Stack.Item>
            <Trait
              fluff={
                <DesiresTraitFluff
                  active={desires.resting}
                  desires={desires?.desires}
                  desc={TRAIT_DESCRIPTION.Desires}
                  bar={
                    desires.resting ? (
                      <TraitBar
                        value={desires.value}
                        label={TRAIT_LABEL.Desires}
                      />
                    ) : undefined
                  }
                />
              }
              title={TRAIT_NAME.Desires}
              img={TRAIT_ASSET.Desires}
            />
          </Stack.Item>
          {!!righteous.present && (
            <Stack.Item>
              <Trait
                fluff={
                  <TraitFluff
                    desc={TRAIT_DESCRIPTION.Holy}
                    bar={
                      <TraitBar
                        value={righteous.value}
                        label={TRAIT_LABEL.Holy}
                      />
                    }
                  />
                }
                title={TRAIT_NAME.Holy}
                img={TRAIT_ASSET.Holy}
              />
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
