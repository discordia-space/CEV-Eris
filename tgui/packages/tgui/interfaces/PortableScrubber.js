import { useBackend } from '../backend';
import { Button, Section, Slider } from '../components';
import { getGasLabel } from '../constants';
import { Window } from '../layouts';
import { PortableBasicInfo } from './common/PortableAtmos';

export const PortableScrubber = (props, context) => {
  const { act, data } = useBackend(context);
  const filter_types = data.filter_types || [];
  return (
    <Window
      width={320}
      height={filter_types ? 426 : 396}>
      <Window.Content>
        <PortableBasicInfo />
        <Section title="Volume Rate">
          {/* todo, easy minmax reset */}
          <Slider
            value={data.current_rate}
            minValue={data.min_rate}
            maxValue={data.max_rate}
            unit={"L/s"} onChange={(e, value) => {
              act('rate', { 'rate': value });
            }} />
        </Section>
        {(!!filter_types || !!filter_types.length) && (
          <Section title="Filters">
            {filter_types.map(filter => (
              <Button
                key={filter.id}
                icon={filter.enabled ? 'check-square-o' : 'square-o'}
                content={getGasLabel(filter.gas_id, filter.gas_name)}
                selected={filter.enabled}
                onClick={() => act('toggle_filter', {
                  val: filter.gas_id,
                })} />
            ))}
          </Section>)}
      </Window.Content>
    </Window>
  );
};
