import { BooleanLike } from 'common/react';
import { useBackend, sendAct, useLocalState } from '../backend';
import {
  Button,
  Box,
  LabeledList,
  Divider,
  Dropdown,
  NumberInput,
  Collapsible,
} from '../components';
import { GameIcon } from '../components/GameIcon';
import { Window } from '../layouts';

interface StorageNodeInterface {
  dosh: number;
  authorization: BooleanLike;
  accountname: string;
  accountnum: number;
  budget: number;
  matnums: number[];
  matnames: string[];
  maticons: string[];
  matvalues: number[];
  sellthreshold: number;
  portmatvalues: number[];
  portmatamounts: number[];
  portmaticons: string[];
  portmatnames: string[];
  idnums: number[];
  iddescs: string[];
  IDcodereq: number;
  otherprimeloc: string;
}

const exchange = (props, context) => {
  const { matnames, matnums, matvalues, dosh, maticons } = props;
  const [selection, setSelection] = useLocalState(
    context,
    'storageexchangeSelection',
    -1,
  );
  const [amt, setAmt] = useLocalState(context, 'storageexchangeAmt', 0);
  const act = sendAct;
  return (
    <>
      {maticons.map((mapped, count: number) => {
        return displayfourstats(
          matnames[count],
          matnums[count],
          matvalues[count],
          maticons[count],
          false,
        );
      })}
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
      {selection !== -1 && amt * matvalues[selection]}
      {selection !== -1 && (
        <Button
          content="Buy Selected"
          onClick={() => {
            setAmt(0);
            setSelection(-1);
            act('buymat', { matselected: selection + 1, amount: amt });
          }}
        />
      )}
      <Divider hidden:true />
      {dosh && 'Card:'}
      {dosh}
      {dosh !== null && (
        <Button content="Logout" onClick={() => act('logout')} />
      )}
    </>
  );
};

const sale = (props, context) => {
  const act = sendAct;
  const {
    budget,
    dosh,
    portmatnames,
    portmatamounts,
    portmaticons,
    portmatvalues,
  } = props;
  const [selection, setSelection] = useLocalState(context, 'saleSelection', -1);
  return (
    <>
      <LabeledList.Item label="Budget">{budget}</LabeledList.Item>
      <LabeledList>
        <LabeledList.Item label="Material Input">
          {portmatnames !== null && (
            <Dropdown
              options={portmatnames}
              onSelected={(value) => setSelection(portmatnames.indexOf(value))}
            />
          )}
          {portmatnames !== null && (
            <Button
              content="Eject Mats"
              onClick={() => {
                setSelection(-1);
                act('eject');
              }}
            />
          )}
          {portmatnames !== null && (
            <Button
              content="Sell Mats"
              onClick={() => {
                setSelection(-1);
                act('sellmat');
              }}
            />
          )}

          {portmaticons &&
            portmaticons.map((mapped, count: number) => {
              return displayfourstats(
                portmatnames[count],
                portmatamounts[count],
                portmatvalues[count],
                portmaticons[count],
                true,
              );
            })}

          {selection !== -1 && (
            <Button
              content="Eject Selected"
              onClick={() => {
                setSelection(-1);
                act('eject', { selected: selection + 1 });
              }}
            />
          )}

          {selection !== -1 && (
            <Button
              content="Sell Selected"
              onClick={() => {
                setSelection(-1);
                act('sellmat', { selected: selection + 1 });
              }}
            />
          )}
        </LabeledList.Item>
      </LabeledList>
      <Box>
        {dosh && 'Card:'}
        {dosh}
        {dosh !== null && (
          <Button content="Logout" onClick={() => act('logout')} />
        )}
      </Box>
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
      {context === true ? value * 0.9 : value * 1.1}
    </Box>
  );
};

const administration = (props, context) => {
  const {
    budget,
    authorization,
    sellthreshold,
    accountname,
    accountnum,
    idnums,
    iddescs,
    IDcodereq,
  } = props;
  const act = sendAct;
  const [newbudget, setBudget] = useLocalState(context, 'amebudget', budget);
  const [newthreshold, setThreshold] = useLocalState(
    context,
    'amethreshold',
    sellthreshold,
  );
  const [newaccount, setAccount] = useLocalState(
    context,
    'ameaccount',
    accountnum,
  );
  return (
    <>
      <LabeledList.Item label="Current Budget">{budget}</LabeledList.Item>
      {authorization && (
        <LabeledList.Item label="Maximum Budget">
          <NumberInput
            value={newbudget}
            onChange={(e, value) => setBudget(value)}
          />
          {authorization && (
            <Button
              content="Set Maximum Budget"
              onClick={() => act('setbudget', { newbudget: newbudget })}
            />
          )}
        </LabeledList.Item>
      )}
      {
        <LabeledList.Item label="Current Sale Threshold">
          {sellthreshold}
        </LabeledList.Item>
      }
      {authorization && (
        <LabeledList.Item label="Maximum Sale Threshold">
          <NumberInput
            value={newthreshold}
            onChange={(e, value) => setThreshold(value)}
          />
        </LabeledList.Item>
      )}
      {authorization && (
        <Button
          content="Set Sale Threshold"
          onClick={() => act('setthreshold', { newthreshold: newthreshold })}
        />
      )}
      {<LabeledList.Item label="Account">{accountname}</LabeledList.Item>}
      {authorization && (
        <NumberInput
          value={newaccount}
          onChange={(e, value) => setAccount(value)}
        />
      )}
      {authorization && (
        <Button
          content="Set Account ID"
          onClick={() => act('setaccount', { newID: newaccount })}
        />
      )}
      {authorization && (
        <Collapsible title="Set Required Access Code">
          {idnums.map((mapped, count: number) => (
            <Button
              content={iddescs[count]}
              selected={IDcodereq === mapped}
              onClick={() => act('setID', { newID: mapped })}
              key={mapped}
            />
          ))}
        </Collapsible>
      )}
    </>
  );
};

export const StorageNode = (props, context) => {
  const { act, data } = useBackend<StorageNodeInterface>(context);
  const {
    dosh,
    budget,
    authorization,
    accountname,
    accountnum,
    matnums,
    matnames,
    maticons,
    matvalues,
    sellthreshold,
    portmatvalues,
    portmatamounts,
    portmaticons,
    portmatnames,
    idnums,
    iddescs,
    IDcodereq,
    otherprimeloc,
  } = data;
  const [menu, setMenu] = useLocalState(
    context,
    'StoragetNodeMenu',
    portmatnames !== null
      ? 'sale'
      : authorization
        ? 'administration'
        : 'materialexchange',
  );
  return (
    <Window resizable>
      <Window.Content scrollable>
        {(otherprimeloc && (
          <>
            {'Location of Prime Silo:'}
            {otherprimeloc}
            <Divider hidden />
            <Button
              content="Reset Prime status"
              onClick={() => act('resetprime')}
            />
          </>
        )) || (
          <>
            <Button
              content="Administration"
              disabled={authorization ? false : true}
              selected={menu === 'administration'}
              onClick={() => setMenu('administration')}
            />
            <Button
              content="Input"
              selected={menu === 'sale'}
              onClick={() => setMenu('sale')}
            />
            <Button
              content="Exchange"
              selected={menu === 'materialexchange'}
              onClick={() => setMenu('materialexchange')}
            />
            <Divider />
            {menu === 'administration' &&
              authorization &&
              administration(
                {
                  budget,
                  authorization,
                  sellthreshold,
                  accountname,
                  accountnum,
                  idnums,
                  iddescs,
                  IDcodereq,
                },
                context,
              )}
            {menu === 'sale' &&
              sale(
                {
                  budget,
                  dosh,
                  portmatnames,
                  portmatamounts,
                  portmaticons,
                  portmatvalues,
                },
                context,
              )}
            {menu === 'materialexchange' &&
              exchange(
                { matnames, matnums, matvalues, dosh, maticons },
                context,
              )}
          </>
        )}
      </Window.Content>
    </Window>
  );
};
