import { BooleanLike } from 'common/react';
import { useBackend, sendAct } from '../backend';
import { Button, Box, Divider, Table } from '../components';
import { GameIcon } from '../components/GameIcon';
import { Window } from '../layouts';
import { ComputerInterface, ProgramShell } from './Computer';
import { classes } from 'common/react';

interface CrewRecordsInterface extends RecordConcrete, ComputerInterface {
  message: string;
  front_pic: string;
  side_pic: string;
  pic_edit: BooleanLike;
  all_records: RecordAbstract[];
  creation: BooleanLike;
  dnasearch: BooleanLike;
  fingersearch: BooleanLike;
}

interface RecordConcrete {
  name: string;
  uid: number;
  creator: string;
  filetime: string;
  fields: RecordField[];
  access: BooleanLike;
  access_edit: BooleanLike;
}
type RecordField = {
  access: BooleanLike;
  access_edit: BooleanLike;
  name: string;
  value: string | number | object;
  list_value: any[];
  list_clumps: object[];
  can_edit: BooleanLike;
  needs_big_box: BooleanLike;
  ignore_value: BooleanLike;
  ID: number;
};

type RecordAbstract = {
  name: string;
  rank: string;
  id: number;
};

export const CrewRecords = (props, context) => {
  const { act, data } = useBackend<CrewRecordsInterface>(context);
  const {
    message,
    uid,
    fields,
    front_pic,
    side_pic,
    pic_edit,
    all_records,
    creation,
    dnasearch,
    fingersearch,
  } = data;
  return (
    <Window resizable>
      <Window.Content scrollable>
        {ProgramShell(props, context)}
        {message && <Button content="X" onClick={() => act('clear_message')} />}
        {message}
        <Divider hidden />
        {uid &&
          currentrecord(
            { uid, fields, front_pic, side_pic, pic_edit },
            context,
          )}
        {Boolean(uid) || (
          <>
            {Boolean(creation) && (
              <>
                <Box className={classes(['oldicons16x16', 'document'])} />
                <Button
                  content="New Record"
                  onClick={() => act('new_record')}
                />
              </>
            )}
            <>
              <Box className={classes(['oldicons16x16', 'search'])} />
              <Button
                content="Name Search"
                onClick={() => act('search', { search: 'Name' })}
              />
            </>
            {Boolean(dnasearch) && (
              <>
                <Box className={classes(['oldicons16x16', 'search'])} />
                <Button
                  content="DNA Search"
                  onClick={() => act('search', { search: 'DNA' })}
                />
              </>
            )}
            {Boolean(fingersearch) && (
              <>
                <Box className={classes(['oldicons16x16', 'search'])} />
                <Button
                  content="Fingerprint Search"
                  onClick={() => act('search', { search: 'Fingerprint' })}
                />
              </>
            )}
            <Divider hidden />
            <Divider hidden />
            <Box as="h2">Available records:</Box>
            <Table width="100%">
              <Table.Row>
                <Table.Cell width="40%">
                  Name<Table.Cell header>Position</Table.Cell>
                </Table.Cell>
              </Table.Row>
              {all_records.map((mapped) => {
                return (
                  <>
                    <Table.Row class="candystripe">
                      <Table.Cell>
                        <Button
                          content={mapped.name + ''}
                          onClick={() =>
                            act('set_active', { set_active: mapped.id })
                          }
                        />
                      </Table.Cell>
                    </Table.Row>
                    <Table.Cell>{mapped.rank}</Table.Cell>
                  </>
                );
              })}
            </Table>
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const currentrecord = (props, context) => {
  const act = sendAct;
  const { uid, fields, front_pic, side_pic, pic_edit } = props;
  return (
    <>
      <Button content="BACK" onClick={() => act('clear_active')} />
      <Button content="PRINT" onClick={() => act('print_active')} />
      <Divider hidden />
      <Box className="statusDisplay" textAlign="center">
        <Box as="h3">GENERIC INFORMATION</Box>
        <Box inline>
          <GameIcon html={front_pic} className="game-icon" />
          <GameIcon html={side_pic} className="game-icon" />
        </Box>
      </Box>

      {Boolean(pic_edit) && (
        <Box>
          <Divider hidden />
          <Box className={classes(['oldicons16x16', 'pencil'])} />
          <Button
            content="Edit Front"
            onClick={() => act('edit_photo_front')}
          />
          <Box className={classes(['oldicons16x16', 'pencil'])} />
          <Button content="Edit Side" onClick={() => act('edit_photo_side')} />
        </Box>
      )}
      {fields &&
        fields.map((mapped) => {
          return displayfield(mapped, context);
        })}
    </>
  );
};
const displayfield = (props, context) => {
  const act = sendAct;
  const {
    access,
    access_edit,
    name,
    value,
    list_value,
    list_clumps,
    can_edit,
    needs_big_box,
    ignore_value,
    ID,
  } = props;
  return (
    <>
      {access && access_edit && (
        <Box>
          <Box className={classes(['oldicons16x16', 'pencil'])} />
          <Button
            content={name}
            onClick={() => act('edit_field', { edit_field: ID })}
          />
        </Box>
      )}
      {access && (Boolean(access_edit) || name)}
      {access && (
        <Box inline={Boolean(needs_big_box)}>
          {value}
          {list_value &&
            (Object.values(list_value).length
              ? list_value.join(', ')
              : 'Unset')}
          {list_clumps &&
            (Object.keys(list_clumps)
              ? Object.keys(list_clumps).map((mapped, count) => {
                  return (
                    <>
                      {mapped}
                      {': '}
                      {returnlist(
                        { origin: list_clumps, whichlist: count },
                        context,
                      )}
                      <Divider hidden />
                    </>
                  );
                })
              : 'Unset')}
        </Box>
      )}
    </>
  );
};

const returnlist = (props, context) => {
  const { origin, whichlist } = props;
  let toreturn: any;
  if (
    Object.values(origin) &&
    typeof Object.values(origin)[whichlist] !== 'undefined' &&
    Array.isArray(Object.values(origin)[whichlist])
  ) {
    let unfoldthis1: any = Object.values(origin)[whichlist];
    let unfoldthis2: any[] = unfoldthis1;
    toreturn = unfoldthis2.toString();
  } else toreturn = 'Sadness';
  return toreturn;
};

/**/
/*
{{if data.message}}
<p>{{:helper.link('X', null, {'clear_message' : 1})}}{{:data.message}}</p>
{{/if}}
{{if data.uid}}
{{:helper.link('BACK', '', {'clear_active' : 1})}}{{:helper.link('PRINT', '', {'print_active' : 1})}}<br><br>
<div class='statusDisplay'>
	<div style="text-align: center">
		<h3>GENERIC INFORMATION</h3>
		<div style="display: inline-block;">
			<img src='front_{{:data.uid}}.png' width = 128px>
			<img src='side_{{:data.uid}}.png' width = 128px>
		</div>
	</div>
	{{if data.pic_edit}}
		<div class='item'>
			<div class='itemLabel'>&nbsp</div>
			<div class='itemBody'>{{:helper.link('Edit Front', 'pencil', {'edit_photo_front' : 1}, null)}}{{:helper.link('Edit Side', 'pencil', {'edit_photo_side' : 1}, null)}}</div>
		</div>
	{{/if}}
	{{for data.fields}}
		{{if value.access}}
			<div class='item'>
				{{if value.access_edit}}
					<div class='itemLabel'>{{:helper.link(value.name, 'pencil', {'edit_field' : value.ID}, null)}}</div>
				{{else}}
					<div class='itemLabel'>{{:value.name}}:</div>
				{{/if}}
				{{if value.needs_big_box}}
					<div style="display: inline-block;">
					{{if value.value}}
						{{:value.value}}
					{{else}}
						{{if value.list_value}}
							{{for value.list_value}}
								{{:value}}
							{{/for}}
						{{else}}
							{{if value.list_clumps}}
								{{for value.list_clumps}}
									{{for value}}
										{{:value}}
									{{/for}}
								{{/for}}
							{{else}}
								{{if value.links}}
									{{for 1 to value.links.len}}
										{{for value.links}}
											
								{{/if}}
							{{/if}}
						{{/if}}
					{{/if}}
					</div>
				{{else}}
					<div class='itemBody'>{{:value.value}}</div>
				{{/if}}
			</div>
		{{/if}}
	{{/for}}
</div>
{{else}}
{{if data.creation}}
	{{:helper.link('New Record', 'document', {'new_record' : 1}, null)}}
{{/if}}
{{:helper.link('Name Search', 'search', {'search' : 'Name'}, null)}}
{{if data.dnasearch}}
	{{:helper.link('DNA Search', 'search', {'search' : 'DNA'}, null)}}
{{/if}}
{{if data.fingersearch}}
	{{:helper.link('Fingerprint Search', 'search', {'search' : 'Fingerprint'}, null)}}
{{/if}}
<br><br>
<h2>Available records:</h2>
<table style="width:100%">
<tr><td style="width:40%">Name<th>Position
{{for data.all_records}}
	<tr class="candystripe"><td>{{:helper.link(value.name, '', {'set_active' : value.id})}}
	<td>{{:value.rank}}
{{/for}}
</table>
{{/if}}
*/
