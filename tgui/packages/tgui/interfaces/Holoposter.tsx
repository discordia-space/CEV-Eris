import { Button, Section, Stack } from 'tgui-core/components';
import { ImageButton } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { useBackend } from '../backend';
import { Window } from '../layouts';

interface HoloposterProps {
	posterTypes: Record<string, string>;
	isRandom: boolean;
	selected: string;
	icon: string;
}

const HoloposterContent = (props: any) => {
	const { act, data } = useBackend<HoloposterProps>();
	const { posterTypes, isRandom, selected, icon } = data;

	return (
		<Stack fill justify="space-between">
			<Stack.Item
				grow
				style={{
					display: 'flex',
				}}
			>
				<ImageButton
					base64={icon}
					style={{
						height: 'auto',
						width: '100%',
					}}
				/>
			</Stack.Item>
			<Stack.Item grow={2}>
				<Section
					fill
					title="Holograms"
					buttons={
						<Button
							icon="random"
							selected={isRandom}
							tooltip={'Toggle poster rotation.'}
							onClick={() => act('random')}
						/>
					}
				>
					{Object.keys(posterTypes).map((value) => (
						<Button
							key={value}
							content={capitalize(value)}
							selected={selected === value}
							onClick={() => act('change', { value: value })}
						/>
					))}
				</Section>
			</Stack.Item>
		</Stack>
	);
};

export const Holoposter = (props: any) => {
	return (
		<Window width={320} height={180}>
			<Window.Content>
				<HoloposterContent />
			</Window.Content>
		</Window>
	);
};
