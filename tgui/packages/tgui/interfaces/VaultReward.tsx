// THIS FILE IS FOR THE VAULT REWARD MENU NOT THE VAULT OBJECT

import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Input,
  Section,
  Stack,
  Table,
  Tooltip,
  Box,
} from '../components';
import { GameIcon } from '../components/GameIcon';
import { Window } from '../layouts';

interface VaultItemData {
  name: string;
  desc: string;
  icon: string;
  cost: number;
  item_type: string;
  loadout_type: string;
}

interface InputData {
  ckey: string;
  iriska_balance: number;
  equipped_items: VaultItemData[];
  items: VaultItemData[];
}

const MAX_PER_PAGE = 15;

export const VaultReward = (props, context) => {
  const { act, data } = useBackend<InputData>(context);
  const { ckey, iriska_balance, equipped_items, items } = data;
  const [searchQuery, setSearchQuery] = useLocalState(
    context,
    'searchQuery',
    '',
  );
  const [currentPage, setCurrentPage] = useLocalState(
    context,
    'currentPage',
    1,
  );

  const filteredItems = items.filter(
    (item) =>
      !equipped_items.some(
        (equippedItem) => equippedItem.item_type === item.item_type,
      ),
  );

  const searchedItems = searchQuery
    ? filteredItems.filter((item) =>
        item.name.toLowerCase().includes(searchQuery.toLowerCase()),
      )
    : filteredItems;

  const paginatedItems = searchedItems.slice(
    (currentPage - 1) * MAX_PER_PAGE,
    currentPage * MAX_PER_PAGE,
  );

  const totalPages = Math.ceil(searchedItems.length / MAX_PER_PAGE);

  const handleItemClick = (type_to_check: string) => {
    if (equipped_items.some((item) => item.item_type === type_to_check)) {
      act('deselect_type', { type: type_to_check });
    } else if (items.some((item) => item.item_type === type_to_check)) {
      act('select_type', { type: type_to_check });
    }
  };

  return (
    <Window width={600} height={700}>
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <UserInfoSection ckey={ckey} balance={iriska_balance} />
          </Stack.Item>
          <Stack.Item>
            <EquippedItemsSection
              items={equipped_items}
              onItemClick={handleItemClick}
            />
          </Stack.Item>
          <Stack.Item>
            <SearchSection
              searchQuery={searchQuery}
              onSearchChange={(value) => {
                setSearchQuery(value);
                setCurrentPage(1);
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <PaginationSection
              currentPage={currentPage}
              totalPages={totalPages}
              onPageChange={setCurrentPage}
            />
          </Stack.Item>
          <Stack.Item>
            <AvailableItemsSection
              items={paginatedItems}
              onItemClick={handleItemClick}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const UserInfoSection = ({ ckey, balance }) => (
  <Section title="User Info">
    <Table>
      <Table.Row>
        <Table.Cell bold>Account Name</Table.Cell>
        <Table.Cell bold>Available Iriski</Table.Cell>
      </Table.Row>
      <Table.Row className="candystripe">
        <Table.Cell>{ckey}</Table.Cell>
        <Table.Cell>
          <Box className="Reward--cost">{balance}</Box>
        </Table.Cell>
      </Table.Row>
    </Table>
  </Section>
);

const EquippedItemsSection = ({ items, onItemClick }) => (
  <Section title="Equipped Items">
    <Table>
      <Table.Row>
        <Table.Cell bold>Name</Table.Cell>
        <Table.Cell bold textAlign="center">
          Cost (Sell, iriski)
        </Table.Cell>
      </Table.Row>
      {items.map((item, i) => (
        <Table.Row key={i} className="candystripe">
          <Table.Cell>
            <Button
              content={item.name}
              onClick={() => onItemClick(item.item_type)}
            />
            <GameIcon html={item.icon} />
          </Table.Cell>
          <Table.Cell textAlign="center">{item.cost}</Table.Cell>
        </Table.Row>
      ))}
    </Table>
  </Section>
);

const SearchSection = ({ searchQuery, onSearchChange }) => (
  <Section title="Search">
    <Input
      fluid
      placeholder="Search items..."
      value={searchQuery}
      onInput={(e, value) => onSearchChange(value)}
    />
  </Section>
);

const PaginationSection = ({ currentPage, totalPages, onPageChange }) => (
  <Section>
    <Stack justify="space-between">
      <Stack.Item>
        <Button
          icon="fast-backward"
          disabled={currentPage === 1}
          onClick={() => onPageChange(1)}
        />
        <Button
          icon="step-backward"
          disabled={currentPage === 1}
          onClick={() => onPageChange(currentPage - 1)}
        />
      </Stack.Item>
      <Stack.Item>
        Page {currentPage} / {totalPages}
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="step-forward"
          disabled={currentPage === totalPages}
          onClick={() => onPageChange(currentPage + 1)}
        />
        <Button
          icon="fast-forward"
          disabled={currentPage === totalPages}
          onClick={() => onPageChange(totalPages)}
        />
      </Stack.Item>
    </Stack>
  </Section>
);

const AvailableItemsSection = ({ items, onItemClick }) => (
  <Section title="Available Items">
    <Table>
      <Table.Row>
        <Table.Cell bold>Name</Table.Cell>
        <Table.Cell bold textAlign="center">
          Cost (Buy, iriski)
        </Table.Cell>
        <Table.Cell bold>Description</Table.Cell>
      </Table.Row>
      {items.map((item, i) => (
        <Table.Row key={i} className="candystripe">
          <Table.Cell>
            <Button
              content={item.name}
              onClick={() => onItemClick(item.item_type)}
            />
            <GameIcon html={item.icon} />
          </Table.Cell>
          <Table.Cell textAlign="center" className="Reward--cost">
            {item.cost}
          </Table.Cell>
          <Table.Cell>
            <Tooltip content={item.desc} position="bottom">
              <Box className="Reward--text">{item.desc}</Box>
            </Tooltip>
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  </Section>
);
