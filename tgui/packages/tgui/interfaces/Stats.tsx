import { useBackend, useLocalState } from '../backend';
import { Box, Section, Stack, Tabs, Tooltip } from '../components';
import { Window } from '../layouts';
import { capitalize } from 'common/string';
import { classes } from 'common/react';

enum TABS {
  stats,
  perks,
}

interface StatData {
  name: string;
  value: number;
}

interface PerkData {
  name: string;
  icon: string;
  desc: string;
}

interface StatsData {
  name: string;
  hasPerks: boolean;
  stats: StatData[];
  perks: PerkData[];
}

const perk = (perk: PerkData) => {
  const { name, icon, desc } = perk;

  return (
    <Stack.Item>
      <Tooltip position="bottom" content={desc}>
        <Stack position="relative" fill>
          <Stack.Item
            className={classes(['Stats__box--icon', 'Stats__content'])}>
            <Box className={classes(['perks32x32', icon])} />
          </Stack.Item>
          <Stack.Item
            grow
            className={classes(['Stats__box--text', 'Stats__content'])}>
            {capitalize(name)}
          </Stack.Item>
        </Stack>
      </Tooltip>
    </Stack.Item>
  );
};

const PerksTab = (props: any, context: any) => {
  const { data } = useBackend<StatsData>(context);
  const { perks } = data;

  return (
    <Stack fill vertical justify="start">
      {perks.map((value, i) => perk(value))}
    </Stack>
  );
};

const stat = (stat: StatData) => {
  const { name, value } = stat;

  return (
    <Stack.Item>
      <Stack fill>
        <Stack.Item
          grow={2}
          className={classes(['Stats__box--skill', 'Stats__content'])}>
          {capitalize(name)}
        </Stack.Item>
        <Stack.Item
          grow={1}
          className={classes(['Stats__box--text', 'Stats__content'])}>
          {value}
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

const StatsTab = (props: any, context: any) => {
  const { data } = useBackend<StatsData>(context);
  const { stats } = data;

  return (
    <Stack fill vertical justify="space-around">
      {stats.map((value, i) => stat(value))}
    </Stack>
  );
};

export const Stats = (props: any, context: any) => {
  const { data } = useBackend<StatsData>(context);
  const { name, hasPerks } = data;

  const [currentTab, setCurrentTab] = useLocalState(
    context,
    'stats_tab',
    TABS.stats
  );

  return (
    <Window width={285} height={295} title={`${name}'s Stats`}>
      <Window.Content style={{ 'background-image': 'none' }}>
        <Stack fill vertical>
          {(hasPerks && (
            <Stack.Item>
              <Tabs fluid>
                <Tabs.Tab
                  selected={currentTab === TABS.stats}
                  onClick={() => setCurrentTab(TABS.stats)}>
                  Stats
                </Tabs.Tab>
                <Tabs.Tab
                  selected={currentTab === TABS.perks}
                  onClick={() => setCurrentTab(TABS.perks)}>
                  Perks
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
          )) ||
            null}

          <Stack.Item grow>
            <Section fill scrollable={currentTab === TABS.perks}>
              {(hasPerks && currentTab === TABS.perks && <PerksTab />) || (
                <StatsTab />
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
