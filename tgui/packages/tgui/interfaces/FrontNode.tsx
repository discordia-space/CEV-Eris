import { BooleanLike } from 'common/react';
import { useBackend, sendAct, useLocalState } from '../backend';
import {
  Button,
  Box,
  LabeledList,
  Divider,
  Dropdown,
  NumberInput,
} from '../components';
import { GameIcon } from '../components/GameIcon';
import { Window } from '../layouts';

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

const recycling = (props, context) => {
  const act = sendAct;
  const { budget, dosh, siloactive, itemnames, icons, itemprices } = props;
  const [selection, setSelection] = useLocalState(
    context,
    'recyclingSelection',
    -1,
  );
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
          />
        )}
        {itemnames[0] && (
          <Button content="Eject Items" onClick={() => act('eject_item')} />
        )}
        {itemnames[0] && siloactive && (
          <Button content="Sell Items" onClick={() => act('sell_item')} />
        )}

        {itemnames[0] && siloactive && (
          <Button content="Recycle Items" onClick={() => act('recycle_item')} />
        )}
        {siloactive &&
          icons.map((mapped, count: number) => {
            return displaythreestats(
              itemnames[count],
              itemprices[count],
              icons[count],
              context,
            );
          })}

        {selection !== -1 && (
          <Button
            content="Eject Selected"
            onClick={() => {
              setSelection(-1);
              act('eject_item', { chosen: selection + 1 });
            }}
          />
        )}

        {selection !== -1 && siloactive && (
          <Button
            content="Sell Selected"
            onClick={() => {
              setSelection(-1);
              act('sell_item', { chosen: selection + 1 });
            }}
          />
        )}

        {selection !== -1 && siloactive && (
          <Button
            content="Recycle Selected"
            onClick={() => {
              setSelection(-1);
              act('recycle_item', { chosen: selection + 1 });
            }}
          />
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

const displaythreestats = (name, value, icon, context) => {
  return (
    <Box inline:true>
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

const exchange = (props, context) => {
  const { matnames, matnums, matvalues, dosh, maticons, siloactive } = props;
  const [selection, setSelection] = useLocalState(
    context,
    'exchangeSelection',
    -1,
  );
  const [amt, setAmt] = useLocalState(context, 'exchangeAmt', 0);
  const act = sendAct;
  return (
    <>
      {siloactive ? (
        maticons.map((mapped, count: number) => {
          return displayfourstats(
            matnames[count],
            matnums[count],
            matvalues[count],
            maticons[count],
            context,
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
      />
      <NumberInput
        value={amt}
        maxValue={selection !== -1 ? matnums[matnames.indexOf(selection)] : 0}
        onChange={(e, value) => setAmt(value)}
      />
      {selection !== -1 && 'price of selection:'}
      {selection !== -1 && amt * matvalues[selection] * 1.2}
      {selection !== -1 && (
        <Button
          content="Buy Selected"
          onClick={() => {
            setSelection(-1);
            setAmt(0);
            act('buy_mat', { matselected: selection + 1, amount: amt });
          }}
        />
      )}
      <Divider hidden:true />
      {dosh && 'Money:'}
      {dosh}
      {dosh && (
        <Button content="Cash Return" onClick={() => act('ejectdosh')} />
      )}
    </>
  );
};

const displayfourstats = (name, _number, value, icon, context) => {
  return (
    <Box inline:true>
      {icon && <GameIcon html={icon} className="game-icon" />}
      <Divider hidden />
      {name}
      {' available: '}
      {_number}
      <Divider hidden />
      {'price per unit '}
      {value * 1.2}
    </Box>
  );
};

const administration = (props, context) => {
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

export const FrontNode = (props, context) => {
  const { act, data } = useBackend<FrontNodeInterface>(context);
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
  const [menu, setMenu] = useLocalState(
    context,
    'FrontNodeMenu',
    itemnames[0] ? 'recycling' : 'materialexchange',
  );
  return (
    <Window resizable>
      <Window.Content scrollable>
        <Button
          content="Administration"
          disabled={authorization ? false : true}
          selected={menu === 'administration'}
          onClick={() => setMenu('administration')}
        />
        <Button
          content="Recycling"
          disabled={salesactive ? false : true}
          selected={menu === 'recycling'}
          onClick={() => setMenu('recycling')}
        />
        <Button
          content="Exchange"
          disabled={siloactive ? false : true}
          selected={menu === 'materialexchange'}
          onClick={() => setMenu('materialexchange')}
        />
        <Divider />
        {menu === 'administration' &&
          authorization &&
          administration({ budget, authorization, siloactive }, context)}
        {menu === 'recycling' &&
          salesactive &&
          recycling(
            { budget, dosh, siloactive, itemnames, icons, itemprices },
            context,
          )}
        {menu === 'materialexchange' &&
          siloactive &&
          exchange(
            { matnames, matnums, matvalues, dosh, maticons, siloactive },
            context,
          )}
      </Window.Content>
    </Window>
  );
};
