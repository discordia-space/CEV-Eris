import { useState } from 'react';
import { sendAct, useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  LabeledList,
  NumberInput,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { GameIcon } from '../components/GameIcon';
import { Window } from '../layouts';

const Recycling = (props) => {
  const act = sendAct;
  const { budget, dosh, siloactive, itemnames, icons, itemprices } = props;
  const [selection, setSelection] = useState<number>(-1);
  return (
    <>
      {siloactive ? (
        <LabeledList.Item label="Budget">{budget}</LabeledList.Item>
      ) : (
        <Box nowrap italic mb="10px">
          {' '}
          {'AME Network Unavailable.'}{' '}
        </Box>
      )}
      <LabeledList>
        {siloactive && itemnames[0] && (
          <Dropdown
            options={itemnames}
            onSelected={(value) => setSelection(itemnames.indexOf(value))}
            selected={selection !== -1 ? itemnames[selection] : ''}
          />
        )}
        {itemnames[0] && (
          <Button onClick={() => act('eject_item')}>Eject Items</Button>
        )}
        {itemnames[0] && siloactive && (
          <Button onClick={() => act('sell_item')}>Sell Items</Button>
        )}

        {itemnames[0] && siloactive && (
          <Button onClick={() => act('recycle_item')}>Recycle Items</Button>
        )}
        {siloactive &&
          icons.map((mapped, count: number) => {
            return (
              <DisplayThreeStats
                key={count}
                name={itemnames[count]}
                value={itemprices[count]}
                icon={icons[count]}
              />
            );
          })}

        {selection !== -1 && (
          <Button
            onClick={() => {
              setSelection(-1);
              act('eject_item', { chosen: selection + 1 });
            }}
          >
            Eject Selected
          </Button>
        )}

        {selection !== -1 && siloactive && (
          <Button
            onClick={() => {
              setSelection(-1);
              act('sell_item', { chosen: selection + 1 });
            }}
          >
            Sell Selected
          </Button>
        )}

        {selection !== -1 && siloactive && (
          <Button
            onClick={() => {
              setSelection(-1);
              act('recycle_item', { chosen: selection + 1 });
            }}
          >
            Recycle Selected
          </Button>
        )}
      </LabeledList>
      <Box>
        {dosh && 'Money:'}
        {dosh}
        {dosh && (
          <Button content="Cash Return" onClick={() => act('ejectdosh')} />
        )}
      </Box>
    </>
  );
};

interface DisplayThreeStatsProps {
  name: string;
  value: number;
  icon: string;
}

const DisplayThreeStats = (props: DisplayThreeStatsProps) => {
  const { name, value, icon } = props;
  return (
    <Box inline>
      {icon && <GameIcon html={icon} className="game-icon" />}
      <Divider hidden />
      {name}
      <Divider hidden />
      {'price for item'} {value * 0.8}
      <Divider hidden />
      {'fee for item'} {value * 0.2}
    </Box>
  );
};

interface ExchangeProps {
  matnames: string[];
  matnums: number[];
  matvalues: number[];
  dosh: number;
  maticons: string[];
  siloactive: BooleanLike;
}

const Exchange = (props: ExchangeProps) => {
  const { matnames, matnums, matvalues, dosh, maticons, siloactive } = props;
  const [selection, setSelection] = useState<number>(-1);
  const [amt, setAmt] = useState(0);
  const act = sendAct;
  return (
    <>
      {siloactive ? (
        maticons.map((mapped, count: number) => {
          return (
            <DisplayFourStats
              key={count}
              name={matnames[count]}
              number={matnums[count]}
              value={matvalues[count]}
              icon={maticons[count]}
            />
          );
        })
      ) : (
        <Box nowrap italic mb="10px">
          {' '}
          {'AME Network Unavailable.'}{' '}
        </Box>
      )}
      <Dropdown
        options={matnames}
        onSelected={(value) => setSelection(matnames.indexOf(value))}
        selected={selection !== -1 ? matnames[selection] : ''}
      />
      <NumberInput
        value={amt}
        maxValue={selection !== -1 ? matnums[matnames[selection]] : 0}
        onChange={(value: number) => setAmt(value)}
        minValue={0}
        step={1}
      />
      {selection !== -1 && 'price of selection:'}
      {selection !== -1 && amt * matvalues[selection] * 1.2}
      {selection !== -1 && (
        <Button
          onClick={() => {
            setSelection(-1);
            setAmt(0);
            act('buy_mat', { matselected: selection + 1, amount: amt });
          }}
        >
          Buy Selected
        </Button>
      )}
      <Divider hidden />
      {dosh && 'Money:'}
      {dosh}
      {dosh && (
        <Button content="Cash Return" onClick={() => act('ejectdosh')} />
      )}
    </>
  );
};

interface DisplayFourStatsProps {
  name: string;
  number: number;
  value: number;
  icon: string;
}
const DisplayFourStats = (props: DisplayFourStatsProps) => {
  const { name, number, value, icon } = props;
  return (
    <Box inline>
      {icon && <GameIcon html={icon} className="game-icon" />}
      <Divider hidden />
      {name}
      {' available: '}
      {number}
      <Divider hidden />
      {'price per unit '}
      {value * 1.2}
    </Box>
  );
};

interface AdministrationProps {
  budget: number;
  authorization: BooleanLike;
  siloactive: BooleanLike;
}

const Administration = (props: AdministrationProps) => {
  const { budget, authorization, siloactive } = props;
  const act = sendAct;
  return (
    <>
      {siloactive ? (
        <LabeledList.Item label="Budget">{budget}</LabeledList.Item>
      ) : (
        <Box nowrap italic mb="10px">
          {' '}
          {'AME Network Unavailable.'}{' '}
        </Box>
      )}
      {authorization && (
        <Button content="Toggle Sales" onClick={() => act('toggle_sales')} />
      )}
    </>
  );
};

interface FrontNodeInterface {
  dosh: number;
  authorization: BooleanLike;
  budget: number;
  siloactive: BooleanLike;
  matnums: number[];
  matnames: string[];
  maticons: string[];
  matvalues: number[];
  salesactive: BooleanLike;
  itemnames: string[];
  icons: string[];
  itemprices: number[];
}

export const FrontNode = (props) => {
  const { act, data } = useBackend<FrontNodeInterface>();
  const {
    dosh,
    budget,
    authorization,
    siloactive,
    salesactive,
    matnums,
    matvalues,
    matnames,
    maticons,
    itemnames,
    icons,
    itemprices,
  } = data;
  const [menu, setMenu] = useState(
    itemnames[0] ? 'recycling' : 'materialexchange',
  );
  return (
    <Window>
      <Window.Content scrollable>
        <Button
          disabled={authorization ? false : true}
          selected={menu === 'administration'}
          onClick={() => setMenu('administration')}
        >
          Administration
        </Button>
        <Button
          disabled={salesactive ? false : true}
          selected={menu === 'recycling'}
          onClick={() => setMenu('recycling')}
        >
          Recycling
        </Button>
        <Button
          disabled={siloactive ? false : true}
          selected={menu === 'materialexchange'}
          onClick={() => setMenu('materialexchange')}
        >
          Exchange
        </Button>
        <Divider />
        {menu === 'administration' && authorization && (
          <Administration
            budget={budget}
            authorization={authorization}
            siloactive={siloactive}
          />
        )}
        {menu === 'recycling' && salesactive && (
          <Recycling
            budget={budget}
            dosh={dosh}
            siloactive={siloactive}
            itemnames={itemnames}
            icons={icons}
            itemprices={itemprices}
          />
        )}
        {menu === 'materialexchange' && siloactive && (
          <Exchange
            matnames={matnames}
            matnums={matnums}
            matvalues={matvalues}
            dosh={dosh}
            maticons={maticons}
            siloactive={siloactive}
          />
        )}
      </Window.Content>
    </Window>
  );
};
