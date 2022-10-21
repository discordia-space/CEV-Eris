import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { CargoCatalog } from './Cargo';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type Data = {
  locked: BooleanLike;
  points: number;
  usingBeacon: BooleanLike;
  beaconzone: string;
  beaconName: string;
  canBuyBeacon: BooleanLike;
  hasBeacon: BooleanLike;
  printMsg: string;
  message: string;
};

export const CargoExpress = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { locked } = data;

  return (
    <Window width={600} height={700}>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox accessText="a QM-level ID card" />
        {!locked && <CargoExpressContent />}
      </Window.Content>
    </Window>
  );
};

const CargoExpressContent = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    hasBeacon,
    message,
    points,
    usingBeacon,
    beaconzone,
    beaconName,
    canBuyBeacon,
    printMsg,
  } = data;

  return (
    <>
      <Section
        title="Cargo Express"
        buttons={
          <Box inline bold>
            <AnimatedNumber value={Math.round(points)} />
            {' credits'}
          </Box>
        }>
        <LabeledList>
          <LabeledList.Item label="Landing Location">
            <Button
              content="Cargo Bay"
              selected={!usingBeacon}
              onClick={() => act('LZCargo')}
            />
            <Button
              selected={usingBeacon}
              disabled={!hasBeacon}
              onClick={() => act('LZBeacon')}>
              {beaconzone} ({beaconName})
            </Button>
            <Button
              content={printMsg}
              disabled={!canBuyBeacon}
              onClick={() => act('printBeacon')}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Notice">{message}</LabeledList.Item>
        </LabeledList>
      </Section>
      <CargoCatalog express />
    </>
  );
};
