import {
	Button,
	LabeledList,
	ProgressBar,
	Section,
	Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const MODE2COLOR = {
	Off: 'bad',
	Panel: 'bad',
	Ready: 'good',
	Pressurizing: 'average',
};

type DisposalUnitData = {
	isai: boolean;
	mode: string;
	panel: boolean;
	eject: boolean;
	handle: boolean;
	pressure: number;
};

export const DisposalUnit = (props: any) => {
	const { act, data } = useBackend<DisposalUnitData>();
	let modeColor = MODE2COLOR[data.panel ? 'Panel' : data.mode];
	let modeText = data.panel ? 'Power Disabled' : data.mode;

	return (
		<Window width={300} height={183} title="Waste Disposal Unit">
			<Window.Content>
				<Section>
					<Stack fill vertical>
						<Stack.Item>
							<LabeledList>
								<LabeledList.Item
									label="Status"
									color={modeColor}
								>
									{modeText}
								</LabeledList.Item>
								<LabeledList.Item label="Pressure">
									<ProgressBar
										value={data.pressure}
										minValue={0}
										maxValue={100}
										ranges={{
											bad: [-Infinity, 0],
											average: [0, 100],
											good: [100, Infinity],
										}}
									/>
								</LabeledList.Item>
								<LabeledList.Item label="Handle">
									<Button
										icon={
											data.handle
												? 'toggle-on'
												: 'toggle-off'
										}
										content={
											data.handle ? 'Disengage' : 'Engage'
										}
										onClick={() => {
											act('toggle', { handle: true });
										}}
										disabled={data.isai}
									/>
								</LabeledList.Item>
								<LabeledList.Item label="Pump">
									<Button
										icon="power-off"
										selected={data.mode !== 'Off'}
										onClick={() => {
											act('toggle', { pump: true });
										}}
										disabled={data.panel}
									/>
								</LabeledList.Item>
							</LabeledList>
						</Stack.Item>
						<Stack.Item>
							<Button
								fluid
								icon="eject"
								disabled={!data.eject}
								textAlign="center"
								onClick={() => {
									act('eject');
								}}
							>
								Eject
							</Button>
						</Stack.Item>
					</Stack>
				</Section>
			</Window.Content>
		</Window>
	);
};
