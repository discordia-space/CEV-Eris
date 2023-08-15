import { useBackend } from '../../backend';
import { Icon, LabeledList, NoticeBox, Section, Stack } from '../../components';

type UserDetailsData = {
  user: UserData;
};

type UserData = {
  name: string;
  cash: number;
  job: string;
  department: string;
};

export const UserDetails = (props, context) => {
  const { data } = useBackend<UserDetailsData>(context);
  const { user } = data;

  if (!user) {
    return <NoticeBox>No ID detected! Contact your supervisor.</NoticeBox>;
  } else {
    return (
      <Section>
        <Stack>
          <Stack.Item>
            <Icon name="id-card" size={3} mr={1} />
          </Stack.Item>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="User">{user.name}</LabeledList.Item>
              <LabeledList.Item label="Occupation">
                {user.job || 'Unemployed'}
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
      </Section>
    );
  }
};
