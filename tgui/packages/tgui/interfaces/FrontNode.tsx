import {
	Box,
	Button,
	Divider,
	Dropdown,
	Image,
	LabeledList,
	NumberInput,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { sendAct, useBackend, useLocalState } from '../backend';
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

const recycling = (props) => {
	const act = sendAct;
	const { budget, dosh, siloactive, itemnames, icons, itemprices } = props;
	const [selection, setSelection] = useLocalState('recyclingSelection', -1);
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
						selected={itemnames[0]}
						options={itemnames}
						onSelected={(value) =>
							setSelection(itemnames.indexOf(value))
						}
					/>
				)}
				{itemnames[0] && (
					<Button onClick={() => act('eject_item')}>
						Eject Items
					</Button>
				)}
				{itemnames[0] && siloactive && (
					<Button onClick={() => act('sell_item')}>Sell Items</Button>
				)}

				{itemnames[0] && siloactive && (
					<Button onClick={() => act('recycle_item')}>
						Recycle Items
					</Button>
				)}
				{siloactive &&
					icons.map((mapped, count: number) => {
						return displaythreestats(
							itemnames[count],
							itemprices[count],
							icons[count],
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
					<Button onClick={() => act('ejectdosh')}>
						Cash Return
					</Button>
				)}
			</Box>
		</>
	);
};

const displaythreestats = (name, value, icon) => {
	return (
		<Box>
			{icon && <Image {...icon} />}
			<Divider hidden />
			{name}
			<Divider hidden />
			{'price for item'} {value * 0.8}
			<Divider hidden />
			{'fee for item'} {value * 0.2}
		</Box>
	);
};

const exchange = (props) => {
	const { matnames, matnums, matvalues, dosh, maticons, siloactive } = props;
	const [selection, setSelection] = useLocalState('exchangeSelection', -1);
	const [amt, setAmt] = useLocalState('exchangeAmt', 0);
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
					);
				})
			) : (
				<Box nowrap italic mb="10px">
					{' '}
					{'AME Network Unavailable.'}{' '}
				</Box>
			)}
			<Dropdown
				selected={matnames[0]}
				options={matnames}
				onSelected={(value) => setSelection(matnames.indexOf(value))}
			/>
			<NumberInput
				step={1}
				value={amt}
				minValue={1}
				maxValue={
					selection !== -1 ? matnums[matnames.indexOf(selection)] : 0
				}
				onChange={(value) => setAmt(value)}
			/>
			{selection !== -1 && 'price of selection:'}
			{selection !== -1 && amt * matvalues[selection] * 1.2}
			{selection !== -1 && (
				<Button
					onClick={() => {
						setSelection(-1);
						setAmt(0);
						act('buy_mat', {
							matselected: selection + 1,
							amount: amt,
						});
					}}
				>
					Buy Selected
				</Button>
			)}
			<Divider hidden />
			{dosh && 'Money:'}
			{dosh}
			{dosh && (
				<Button onClick={() => act('ejectdosh')}>Cash Return</Button>
			)}
		</>
	);
};

const displayfourstats = (name, _number, value, icon) => {
	return (
		<Box>
			{icon && <Image {...icon} />}
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

const administration = (props) => {
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
				<Button onClick={() => act('toggle_sales')}>
					Toggle Sales
				</Button>
			)}
		</>
	);
};

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
	const [menu, setMenu] = useLocalState(
		'FrontNodeMenu',
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
				{menu === 'administration' &&
					authorization &&
					administration({ budget, authorization, siloactive })}
				{menu === 'recycling' &&
					salesactive &&
					recycling({
						budget,
						dosh,
						siloactive,
						itemnames,
						icons,
						itemprices,
					})}
				{menu === 'materialexchange' &&
					siloactive &&
					exchange({
						matnames,
						matnums,
						matvalues,
						dosh,
						maticons,
						siloactive,
					})}
			</Window.Content>
		</Window>
	);
};
