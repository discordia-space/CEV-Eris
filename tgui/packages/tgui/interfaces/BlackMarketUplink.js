import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Modal, Section, Stack, Tabs } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

export const BlackMarketUplink = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    categories = [],
    markets = [],
    items = [],
    money,
    viewing_market,
    viewing_category,
  } = data;
  return (
    <Window width={670} height={480} theme="hackerman">
      <ShipmentSelector />
      <Window.Content scrollable>
        <Section
          title="Black Market Uplink"
          buttons={
            <Box inline bold>
              <AnimatedNumber
                value={money}
                format={(value) => formatMoney(value) + ' cr'}
              />
            </Box>
          }
        />
        <Tabs>
          {markets.map((market) => (
            <Tabs.Tab
              key={market.id}
              selected={market.id === viewing_market}
              onClick={() =>
                act('set_market', {
                  market: market.id,
                })
              }>
              {market.name}
            </Tabs.Tab>
          ))}
        </Tabs>
        <Stack>
          <Stack.Item>
            <Tabs vertical>
              {categories.map((category) => (
                <Tabs.Tab
                  key={category}
                  mt={0.5}
                  selected={viewing_category === category}
                  onClick={() =>
                    act('set_category', {
                      category: category,
                    })
                  }>
                  {category}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            {items.map((item) => (
              <Box key={item.name} className="candystripe" p={1} pb={2}>
                <Stack align="baseline">
                  <Stack.Item grow bold>
                    {item.name}
                  </Stack.Item>
                  <Stack.Item color="label">
                    {item.amount ? item.amount + ' in stock' : 'Out of stock'}
                  </Stack.Item>
                  <Stack.Item>{formatMoney(item.cost) + ' cr'}</Stack.Item>
                  <Stack.Item>
                    <Button
                      content="Buy"
                      disabled={!item.amount || item.cost > money}
                      onClick={() =>
                        act('select', {
                          item: item.id,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
                {item.desc}
              </Box>
            ))}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ShipmentSelector = (props, context) => {
  const { act, data } = useBackend(context);
  const { buying, ltsrbt_built, money } = data;
  if (!buying) {
    return null;
  }
  const deliveryMethods = data.delivery_methods.map((method) => {
    const description = data.delivery_method_description[method.name];
    return {
      ...method,
      description,
    };
  });
  return (
    <Modal textAlign="center">
      <Stack mb={1}>
        {deliveryMethods.map((method) => {
          if (method.name === 'LTSRBT' && !ltsrbt_built) {
            return null;
          }
          return (
            <Stack.Item key={method.name} mx={1} width="17.5rem">
              <Box fontSize="30px">{method.name}</Box>
              <Box mt={1}>{method.description}</Box>
              <Button
                mt={2}
                content={formatMoney(method.price) + ' cr'}
                disabled={money < method.price}
                onClick={() =>
                  act('buy', {
                    method: method.name,
                  })
                }
              />
            </Stack.Item>
          );
        })}
      </Stack>
      <Button content="Cancel" color="bad" onClick={() => act('cancel')} />
    </Modal>
  );
};
