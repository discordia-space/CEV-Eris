import { BooleanLike } from 'common/react';
import { Button, Box, Table } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { sendAct } from '../backend';

export interface ComputerInterface {
  PC_batteryicon: string;
  PC_batterypercent: string;
  PC_showbatteryicon: BooleanLike;
  PC_light_name: string;
  PC_light_on: BooleanLike;
  PC_apclinkicon: string;
  PC_ntneticon: string;
  has_gps: BooleanLike;
  gps_icon: string;
  gps_data: string;
  PC_programheaders: Programheader[];
  PC_stationtime: string;
  PC_hasheader: BooleanLike;
  PC_showexitprogram: BooleanLike;
  mapZLevels: number[];
  mapZLevel: number;
}

type Programheader = {
  icon: string;
};

export const ProgramShell = (props, context) => {
  const {
    PC_batteryicon,
    PC_batterypercent,
    PC_showbatteryicon,
    PC_light_name,
    PC_light_on,
    PC_apclinkicon,
    PC_ntneticon,
    has_gps,
    gps_icon,
    gps_data,
    PC_programheaders,
    PC_stationtime,
    PC_hasheader,
    PC_showexitprogram,
    mapZLevels,
    mapZLevel,
  } = props;
  const act = sendAct;
  return (
    <>
      <Box id="uiHeaderContent" unselectable="on">
        {
          // Add a template with the key "headerContent" to have it rendered here -->
        }
        {PC_hasheader}
        <Box class="uiModularHeader">
          <Box left>
            <Box p="0px">
              <Table>
                <TableRow>
                  {PC_batteryicon && PC_showbatteryicon && (
                    <TableCell>
                      <Box as="img" src={PC_batteryicon} />
                    </TableCell>
                  )}
                  {PC_batterypercent && PC_showbatteryicon && (
                    <TableCell>
                      <Box bold>{PC_batterypercent}</Box>
                    </TableCell>
                  )}
                  {PC_ntneticon && (
                    <TableCell>
                      <Box as="img" src={PC_ntneticon} />
                    </TableCell>
                  )}
                  {PC_apclinkicon && (
                    <TableCell>
                      <Box as="img" src={PC_apclinkicon} />
                    </TableCell>
                  )}
                  {PC_stationtime && (
                    <TableCell>
                      <Box bold>{PC_stationtime}</Box>
                    </TableCell>
                  )}
                  {PC_programheaders &&
                    PC_programheaders.map((mapped) => (
                      <TableCell key={mapped}>
                        <Box as="img" src={mapped.icon} />
                      </TableCell>
                    ))}
                </TableRow>
              </Table>
            </Box>
          </Box>
          <Box float="right" left="5px">
            <Table>
              <TableRow>
                {PC_light_name && (
                  <TableCell>
                    <Button
                      onClick={() =>
                        act('PC_toggle_component', {
                          component: PC_light_name,
                        })
                      }
                    />
                  </TableCell>
                )}
                <TableCell>
                  <Button
                    content="Shutdown"
                    onClick={() => act('PC_shutdown')}
                  />
                </TableCell>
              </TableRow>
            </Table>
          </Box>
          <Box clear="both" />
          {has_gps && (
            <Box
              border-top-width="3px"
              border-top-style="double"
              border-top-color="#7B7B7B"
              p="0px"
            >
              <Table>
                <TableRow>
                  <TableCell>
                    <Box as="img" src={gps_icon} />
                  </TableCell>
                  <TableCell>{gps_data}</TableCell>
                </TableRow>
              </Table>
            </Box>
          )}
        </Box>
      </Box>
      <Box id="uiTitleWrapper" unselectable="on">
        <Box id="uiStatusIcon" class="icon24 uiStatusGood" unselectable="on" />

        {PC_showexitprogram && (
          <Box id="uiTitleButtons">
            <Table>
              <TableRow>
                <TableCell>
                  <Button
                    content="Exit Program"
                    onClick={() => act('PC_exit')}
                  />
                </TableCell>
                <TableCell>
                  <Button
                    content="Minimize Program"
                    onClick={() => act('PC_minimize')}
                  />
                </TableCell>
              </TableRow>
            </Table>
          </Box>
        )}
        {PC_showexitprogram || <Box id="uiTitleFluff" unselectable="on" />}
      </Box>
      <Box id="uiContent" unselectable="on">
        <Box id="uiLoadingNotice">Initiating...</Box>
      </Box>
    </>
  );
};
