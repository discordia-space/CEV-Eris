import { capitalize } from 'common/string';
import { useBackend } from '../backend';
import { BlockQuote, Box, Button, Icon, LabeledList, Modal, NoticeBox, Section, Stack } from '../components';
import { GameIcon } from '../components/GameIcon';
import { Window } from '../layouts';

interface OwnerData {
  name: string;
  dept: string;
}

interface ErrorData {
  message: string;
  isError: boolean;
}

interface VendingProductData extends ErrorData {
  name: string;
  desc: string;
  price: number;
}

interface ProductData {
  key: number;
  name: string;
  icon: string;
  price: number;
  color?: null;
  amount: number;
}

interface VendingData {
  name: string;
  panel: boolean;
  isCustom: string;
  ownerData?: OwnerData;
  isManaging: boolean;
  managingData: ErrorData;
  isVending: boolean;
  vendingData: VendingProductData;
  products?: ProductData[];
  markup?: number;
  speaker?: string;
  advertisement?: string;
}

const managing = (managingData: ErrorData, context: any) => {
  const { act } = useBackend<VendingData>(context);

  return (
    <>
      <Stack.Item>
        {managingData.message.length > 0 && (
          <NoticeBox
            style={{
              'overflow': 'hidden',
              'word-break': 'break-all',
            }}>
            {managingData.message}
          </NoticeBox>
        )}
      </Stack.Item>
      <Stack.Item>
        <Stack justify="space-between" textAlign="center">
          <Stack.Item grow>
            <Button
              fluid
              ellipsis
              icon="building"
              content="Organization"
              onClick={() => act('setdepartment')}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              ellipsis
              icon="id-card"
              content="Account"
              onClick={() => act('setaccount')}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              ellipsis
              icon="tags"
              content="Markup"
              onClick={() => act('markup')}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </>
  );
};

const custom = (props: any, context: any) => {
  const { act, data } = useBackend<VendingData>(context);
  const { ownerData } = data;

  return (
    <Section title={data.isManaging ? 'Managment' : 'Commercial Info'}>
      <Stack fill vertical>
        <Stack>
          <Stack.Item align="center">
            <Icon name="toolbox" size={3} mx={1} />
          </Stack.Item>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Owner">
                {ownerData?.name || 'Unknown'}
              </LabeledList.Item>
              <LabeledList.Item label="Department">
                {ownerData?.dept || 'Not Specified'}
              </LabeledList.Item>
              <LabeledList.Item label="Murkup">
                {(data?.markup && data?.markup > 0 && (
                  <Box>{data.markup}</Box>
                )) ||
                  'None'}
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
        {(data.isManaging && managing(data.managingData, context)) || null}
      </Stack>
    </Section>
  );
};

const product = (product: ProductData, context: any) => {
  const { act, data } = useBackend<VendingData>(context);

  return (
    <Stack.Item>
      <Stack fill height="5.9ch">
        <Stack.Item grow>
          <Button
            fluid
            ellipsis
            onClick={() => act('vend', { key: product.key })}>
            <Stack fill align="center">
              <Stack.Item>
                <GameIcon html={product.icon} className="Vending--game-icon" />
              </Stack.Item>
              <Stack.Item grow={4} textAlign="left" className="Vending--text">
                {product.name}
              </Stack.Item>
              <Stack.Item grow textAlign="right" className="Vending--text">
                {product.amount}
                <Icon name="box" pl="0.6em" />
              </Stack.Item>
              {(product.price > 0 && (
                <Stack.Item grow textAlign="right" className="Vending--text">
                  {product.price}
                  <Icon name="money-bill" pl="0.6em" />
                </Stack.Item>
              )) ||
                null}
            </Stack>
          </Button>
        </Stack.Item>
        {(data.isManaging && (
          <>
            <Stack.Item fill>
              <Button
                icon="tag"
                color="yellow"
                title="Change Price"
                className="Vending--icon"
                verticalAlignContent="middle"
                onClick={() => act('setprice', { key: product.key })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="eject"
                color="red"
                title="Remove"
                className="Vending--icon"
                verticalAlignContent="middle"
                onClick={() => act('remove', { key: product.key })}
              />
            </Stack.Item>
          </>
        )) ||
          null}
      </Stack>
    </Stack.Item>
  );
};

const pay = (vendingProduct: VendingProductData, context: any) => {
  const { act } = useBackend<VendingData>(context);

  return (
    <Modal className="Vending--modal">
      <Stack fill vertical justify="space-between">
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Name">
              {capitalize(vendingProduct.name)}
            </LabeledList.Item>
            <LabeledList.Item label="Description">
              {vendingProduct.desc}
            </LabeledList.Item>
            <LabeledList.Item label="Price">
              {vendingProduct.price}
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <NoticeBox color={vendingProduct.isError ? 'red' : ''}>
            {vendingProduct.message}
          </NoticeBox>
        </Stack.Item>
        <Stack.Item>
          <Button
            fluid
            icon="ban"
            color="red"
            content="Cancel"
            className="Vending--cancel"
            verticalAlignContent="middle"
            onClick={() => act('cancelpurchase')}
          />
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

export const Vending = (props: any, context: any) => {
  const { act, data } = useBackend<VendingData>(context);

  return (
    <Window width={450} height={600} title={`Vending Machine - ${data.name}`}>
      <Window.Content>
        <Stack fill vertical>
          {(data.isCustom && (
            <Stack.Item>{custom(data, context)}</Stack.Item>
          )) ||
            null}
          {(data.panel && (
            <Stack.Item>
              <Button
                fluid
                bold
                my={1}
                py={1}
                icon={data.speaker ? 'comment' : 'comment-slash'}
                content={`Speaker ${data.speaker ? 'Enabled' : 'Disabled'}`}
                textAlign="center"
                color={data.speaker ? 'green' : 'red'}
                onClick={() => act('togglevoice')}
              />
            </Stack.Item>
          )) ||
            null}
          {(data.advertisement && data.advertisement.length > 0 && (
            <Stack.Item>
              <Section>
                <BlockQuote>{data.advertisement}</BlockQuote>
              </Section>
            </Stack.Item>
          )) ||
            null}
          <Stack.Item grow>
            <Section scrollable fill title="Products">
              <Stack fill vertical>
                {data.products &&
                  data.products.map((value, i) => product(value, context))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
      {(data.isVending && pay(data.vendingData, context)) || null}
    </Window>
  );
};
