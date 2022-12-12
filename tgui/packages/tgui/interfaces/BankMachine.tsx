import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { AnimatedNumber, Button, LabeledList, NoticeBox, Section } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

type Data = {
  current_balance: number;
  siphoning: BooleanLike;
  station_name: string;
};

export const BankMachine = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { current_balance, siphoning, station_name } = data;

  return (
    <Window width={350} height={155}>
      <Window.Content>
        <NoticeBox danger>Authorized personnel only</NoticeBox>
        <Section title={station_name + ' Vault'}>
          <LabeledList>
            <LabeledList.Item
              label="Current Balance"
              buttons={
                <Button
                  icon={siphoning ? 'times' : 'sync'}
                  content={siphoning ? 'Stop Siphoning' : 'Siphon Credits'}
                  selected={siphoning}
                  onClick={() => act(siphoning ? 'halt' : 'siphon')}
                />
              }>
              <AnimatedNumber
                value={current_balance}
                format={(value) => formatMoney(value)}
              />
              {' cr'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
