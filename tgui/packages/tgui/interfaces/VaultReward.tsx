import { useBackend, useLocalState } from '../backend';
import { Button, Input, Section, Stack, Table } from '../components';
import { GameIcon } from '../components/GameIcon';
import { Window } from '../layouts';

interface VaultItemData {
    name: string;
    desc: string;
    icon: string;
    cost: number;
    item_type: string;
}

interface InputData {
    ckey: string,
    iriska_balance: number;
    equipped_items: VaultItemData[];
    items: VaultItemData[];
}

const MAX_PER_PAGE = 15;
const numberWithinRange = (min: number, n: number, max: number) =>
    Math.min(Math.max(n, min), max);

const paginator = (items: VaultItemData[], context: any) => {
    const [currentPage, setCurrentPage] = useLocalState(
        context,
        'currentPage',
        1
    );
    const totalPages = Math.ceil(items.length / MAX_PER_PAGE);

    return (
        <Stack width="100%" justify="space-between">
            <Stack.Item>
                <Button icon="fast-backward" onClick={() => setCurrentPage(1)} />
                <Button
                    icon="step-backward"
                    onClick={() =>
                        setCurrentPage(numberWithinRange(1, currentPage - 1, totalPages))
                    }
                />
            </Stack.Item>
            <Stack.Item>
                {currentPage} / {totalPages}
            </Stack.Item>
            <Stack.Item>
                <Button
                    icon="step-forward"
                    onClick={() =>
                        setCurrentPage(numberWithinRange(1, currentPage + 1, totalPages))
                    }
                />
                <Button
                    icon="fast-forward"
                    onClick={() => setCurrentPage(totalPages)}
                />
            </Stack.Item>
        </Stack>
    );
};

export const VaultReward = (props: any, context: any) => {
    const { act, data } = useBackend<InputData>(context);
    const [searchQuery, setSearchQuery] = useLocalState(
        context,
        'searchQuery',
        null
    );
    const [currentPage, setCurrentPage] = useLocalState(
        context,
        "currentPage",
        1
    );

    const handleItemClick = (type_to_check: string) => {
        if (data.equipped_items.some((item, _, __) => item.item_type === type_to_check)) {
            act('deselect_type', { type: type_to_check });
        } else if (data.items.some((item, _, __) => item.item_type === type_to_check)) {
            act('select_type', { type: type_to_check });
        }
    };

    let equipped_items: VaultItemData[] = data.equipped_items;

    let itemsToDisplay: VaultItemData[] = data.items.filter(
        (vault_item, _) =>
            !equipped_items.some(
                (equippedItem, _, __) => equippedItem.item_type === vault_item.item_type
            )
    );

    if (searchQuery !== null) {
        itemsToDisplay = itemsToDisplay.filter(
            (vault_item, _) => vault_item && vault_item.name && vault_item.name.search(searchQuery) >= 0
        );
        equipped_items = equipped_items.filter(
            (vault_item, _) => vault_item && vault_item.name && vault_item.name.search(searchQuery) >= 0
        );
    }

    return (
        <Window>
            <Window.Content scrollable>
                <Section title="User Info">
                    <Table>
                        <Table.Row>
                            <Table.Cell textAlign="center" bold>
                                Account Name
                            </Table.Cell>
                            <Table.Cell textAlign="center" bold>
                                Avaliable iriski
                            </Table.Cell>
                        </Table.Row>
                        <Table.Row className="candystripe" key>
                            <Table.Cell textAlign="center">
                                {data.ckey}
                            </Table.Cell>
                            <Table.Cell textAlign="center" className="Reward--cost">
                                {data.iriska_balance}
                            </Table.Cell>
                        </Table.Row>
                    </Table>
                </Section>
                <Section title="Equipped Items">
                    <Table>
                        <Table.Row>
                            <Table.Cell textAlign="center" bold>
                                Name
                            </Table.Cell>
                            <Table.Cell textAlign="center" bold>
                                Cost (Sell, iriski)
                            </Table.Cell>
                        </Table.Row>
                        {equipped_items.map((item, i) => {
                            return (
                                <Table.Row className="candystripe" key={i}>
                                    <Table.Cell>
                                        <Button
                                            content={item.name}
                                            onClick={() => handleItemClick(item.item_type)}
                                        />
                                        <GameIcon html={item.icon} />
                                    </Table.Cell>
                                    <Table.Cell textAlign="center">{item.cost}</Table.Cell>
                                </Table.Row>
                            );
                        })}
                    </Table>
                </Section>
                <Section className="Search" title="Search">
                    <Input
                        placeholder="Search"
                        fluid
                        onInput={(e: any) => {
                            setCurrentPage(1);
                            setSearchQuery(e.target.value);
                        }}
                    />
                </Section>
                {paginator(itemsToDisplay, context)}
                <Section title="Avaliable Items">
                    <Table>
                        <Table.Row>
                            <Table.Cell textAlign="center" bold>
                                Name
                            </Table.Cell>
                            <Table.Cell textAlign="center" bold>
                                Cost (Buy, iriski)
                            </Table.Cell>
                            <Table.Cell textAlign="center" bold>
                                Description
                            </Table.Cell>
                        </Table.Row>
                        {itemsToDisplay.slice(
                            (currentPage - 1) * MAX_PER_PAGE,
                            currentPage * MAX_PER_PAGE
                        ).map((item, i) => {
                            return (
                                <Table.Row className="candystripe" key={i}>
                                    <Table.Cell>
                                        <Button
                                            content={item.name}
                                            onClick={() => handleItemClick(item.item_type)}
                                        />
                                        <GameIcon html={item.icon} />
                                    </Table.Cell>
                                    <Table.Cell textAlign="center" className="Reward--cost">{item.cost}</Table.Cell>
                                    <Table.Cell textAlign="center">{item.desc}</Table.Cell>
                                </Table.Row>
                            );
                        })}
                    </Table>
                </Section>
            </Window.Content>
        </Window>
    );
};
