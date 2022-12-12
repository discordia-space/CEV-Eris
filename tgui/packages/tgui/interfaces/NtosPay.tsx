import { NtosWindow } from '../layouts';
import { useBackend } from '../backend';
import { Stack, Section, Box, Button, Input, Table, Tooltip, NoticeBox, Divider, RestrictedInput } from '../components';

type Data = {
  name: string;
  owner_token: string;
  money: number;
  transaction_list: Transactions[];
  wanted_token: string;
};

type Transactions = {
  adjusted_money: number;
  reason: string;
};
let name_to_token, money_to_send, token;

export const NtosPay = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { name } = data;

  if (!name) {
    return (
      <NtosWindow width={512} height={130}>
        <NtosWindow.Content>
          <NoticeBox>
            You need to insert your ID card into the card slot in order to use
            this application.
          </NoticeBox>
        </NtosWindow.Content>
      </NtosWindow>
    );
  }

  return (
    <NtosWindow width={495} height={655}>
      <NtosWindow.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Introduction />
          </Stack.Item>
          <Stack.Item>
            <TransferSection />
          </Stack.Item>
          <Stack.Item grow>
            <TransactionHistory />
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

/** Displays the user's name and balance. */
const Introduction = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { name, owner_token, money } = data;
  return (
    <Section textAlign="center">
      <Table>
        <Table.Row>Hi, {name}.</Table.Row>
        <Table.Row>Your pay token is {owner_token}.</Table.Row>
        <Table.Row>
          Account balance: {money} credit{money === 1 ? '' : 's'}
        </Table.Row>
      </Table>
    </Section>
  );
};

/** Displays the transfer section. */
const TransferSection = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { money, wanted_token } = data;

  return (
    <Stack>
      <Stack.Item>
        <Section vertical title="Transfer Money">
          <Box>
            <Tooltip
              content="Enter the pay token of the account you want to trasfer credits."
              position="top">
              <Input
                placeholder="Pay Token"
                width="190px"
                onChange={(e, value) => (token = value)}
              />
            </Tooltip>
          </Box>
          <Tooltip
            content="Enter amount of credits to transfer."
            position="top">
            <RestrictedInput
              width="83px"
              minValue={1}
              maxValue={money}
              onChange={(_, value) => (money_to_send = value)}
              value={1}
            />
          </Tooltip>
          <Button
            content="Send credits"
            onClick={() =>
              act('Transaction', {
                token: token,
                amount: money_to_send,
              })
            }
          />
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Get Token" width="270px" height="98px">
          <Box>
            <Input
              placeholder="Full name of account."
              width="190px"
              onChange={(e, value) => (name_to_token = value)}
            />
            <Button
              content="Get it"
              onClick={() =>
                act('GetPayToken', {
                  wanted_name: name_to_token,
                })
              }
            />
          </Box>
          <Divider hidden />
          <Box nowrap>{wanted_token}</Box>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

/** Displays the transaction history. */
const TransactionHistory = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { transaction_list = [] } = data;

  return (
    <Section fill title="Transaction History">
      <Section fill scrollable title={<TableHeaders />}>
        <Table>
          {transaction_list.map((log) => (
            <Table.Row
              key={log}
              className="candystripe"
              color={log.adjusted_money < 1 ? 'red' : 'green'}>
              <Table.Cell width="100px">
                {log.adjusted_money > 1 ? '+' : ''}
                {log.adjusted_money}
              </Table.Cell>
              <Table.Cell textAlign="center">{log.reason}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};

/** Renders a set of sticky headers */
const TableHeaders = (props, context) => {
  return (
    <Table>
      <Table.Row>
        <Table.Cell color="label" width="100px">
          Amount
        </Table.Cell>
        <Table.Cell color="label" textAlign="center">
          Reason
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};
