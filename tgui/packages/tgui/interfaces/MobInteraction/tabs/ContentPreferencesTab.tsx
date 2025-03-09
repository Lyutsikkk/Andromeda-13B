import { useBackend } from '../../../backend';
import { Button, Stack } from '../../../components';

type ContentPrefsInfo = {
  verb_consent: boolean,
  lewd_verb_sounds: boolean,
  arousable: boolean,
  genital_examine: boolean,
  vore_examine: boolean,
  medihound_sleeper: boolean,
  eating_noises: boolean,
  digestion_noises: boolean,
  trash_forcefeed: boolean,
  forced_fem: boolean,
  forced_masc: boolean,
  hypno: boolean,
  bimbofication: boolean,
  breast_enlargement: boolean,
  penis_enlargement: boolean,
  butt_enlargement: boolean,
  belly_inflation: boolean,
  never_hypno: boolean,
  no_aphro: boolean,
  no_ass_slap: boolean,
  no_auto_wag: boolean,
  chastity_pref: boolean,
  stimulation_pref: boolean,
  edging_pref: boolean,
  cum_onto_pref: boolean,
}

export const ContentPreferencesTab = (props, context) => {
  const { act, data } = useBackend<ContentPrefsInfo>(context);
  const {
    verb_consent,
    lewd_verb_sounds,
    arousable,
    genital_examine,
    vore_examine,
    medihound_sleeper,
    eating_noises,
    digestion_noises,
    trash_forcefeed,
    forced_fem,
    forced_masc,
    hypno,
    bimbofication,
    breast_enlargement,
    penis_enlargement,
    butt_enlargement,
    belly_inflation,
    never_hypno,
    no_aphro,
    no_ass_slap,
    no_auto_wag,
    chastity_pref,
    stimulation_pref,
    edging_pref,
    cum_onto_pref,
  } = data;
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Допускать непристойности"
          icon={verb_consent ? "toggle-on" : "toggle-off"}
          selected={verb_consent}
          onClick={() => act('pref', {
            pref: 'verb_consent',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Непристойные звуки"
          icon={lewd_verb_sounds ? "volume-up" : "volume-mute"}
          selected={lewd_verb_sounds}
          onClick={() => act('pref', {
            pref: 'lewd_verb_sounds',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Возможность возбуждаться"
          icon={arousable ? "toggle-on" : "toggle-off"}
          selected={arousable}
          onClick={() => act('pref', {
            pref: 'arousable',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Просмотр гениталий"
          icon={genital_examine ? "toggle-on" : "toggle-off"}
          selected={genital_examine}
          onClick={() => act('pref', {
            pref: 'genital_examine',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Просмотр Воре"
          icon={vore_examine ? "toggle-on" : "toggle-off"}
          selected={vore_examine}
          onClick={() => act('pref', {
            pref: 'vore_examine',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Борги не могут есть"
          icon={medihound_sleeper ? "toggle-on" : "toggle-off"}
          selected={medihound_sleeper}
          onClick={() => act('pref', {
            pref: 'medihound_sleeper',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Воре звуки"
          icon={eating_noises ? "volume-up" : "volume-mute"}
          selected={eating_noises}
          onClick={() => act('pref', {
            pref: 'eating_noises',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Воре звуки переваривания"
          icon={digestion_noises ? "volume-up" : "volume-mute"}
          selected={digestion_noises}
          onClick={() => act('pref', {
            pref: 'digestion_noises',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Тебя кормят мусором (нужна черта Мусорный Бак)"
          icon={trash_forcefeed ? "toggle-on" : "toggle-off"}
          selected={trash_forcefeed}
          onClick={() => act('pref', {
            pref: 'trash_forcefeed',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Принудительная Женственность (Феминизация)"
          icon={forced_fem ? "toggle-on" : "toggle-off"}
          selected={forced_fem}
          onClick={() => act('pref', {
            pref: 'forced_fem',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Принудительная Маскулинность (Мужификация?)"
          icon={forced_masc ? "toggle-on" : "toggle-off"}
          selected={forced_masc}
          onClick={() => act('pref', {
            pref: 'forced_masc',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="ERP Гипноз"
          icon={hypno ? "toggle-on" : "toggle-off"}
          selected={hypno}
          onClick={() => act('pref', {
            pref: 'hypno',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Bimbofication"
          icon={bimbofication ? "toggle-on" : "toggle-off"}
          selected={bimbofication}
          onClick={() => act('pref', {
            pref: 'bimbofication',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Увеличение груди"
          icon={breast_enlargement ? "toggle-on" : "toggle-off"}
          selected={breast_enlargement}
          onClick={() => act('pref', {
            pref: 'breast_enlargement',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Увеличение пениса"
          icon={penis_enlargement ? "toggle-on" : "toggle-off"}
          selected={penis_enlargement}
          onClick={() => act('pref', {
            pref: 'penis_enlargement',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Увеличение попы"
          icon={butt_enlargement ? "toggle-on" : "toggle-off"}
          selected={butt_enlargement}
          onClick={() => act('pref', {
            pref: 'butt_enlargement',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Увеличение живота"
          icon={belly_inflation ? "toggle-on" : "toggle-off"}
          selected={belly_inflation}
          onClick={() => act('pref', {
            pref: 'belly_inflation',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Обычный гипноз"
          icon={never_hypno ? "toggle-on" : "toggle-off"}
          selected={never_hypno}
          onClick={() => act('pref', {
            pref: 'never_hypno',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Реакция на Афродизиак"
          icon={no_aphro ? "toggle-on" : "toggle-off"}
          selected={no_aphro}
          onClick={() => act('pref', {
            pref: 'no_aphro',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Шлепанье по заднице"
          icon={no_ass_slap ? "toggle-on" : "toggle-off"}
          selected={no_ass_slap}
          onClick={() => act('pref', {
            pref: 'no_ass_slap',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Авто виляние хвоста"
          icon={no_auto_wag ? "toggle-on" : "toggle-off"}
          selected={no_auto_wag}
          onClick={() => act('pref', {
            pref: 'no_auto_wag',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Chastity Interactions"
          icon={chastity_pref ? "toggle-on" : "toggle-off"}
          selected={chastity_pref}
          onClick={() => act('pref', {
            pref: 'chastity_pref',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Модификаторы стимуляции гениталий"
          icon={stimulation_pref ? "toggle-on" : "toggle-off"}
          selected={stimulation_pref}
          onClick={() => act('pref', {
            pref: 'stimulation_pref',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Edging"
          icon={edging_pref ? "toggle-on" : "toggle-off"}
          selected={edging_pref}
          onClick={() => act('pref', {
            pref: 'edging_pref',
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          content="Покрываться кончёй"
          icon={cum_onto_pref ? "toggle-on" : "toggle-off"}
          selected={cum_onto_pref}
          onClick={() => act('pref', {
            pref: 'cum_onto_pref',
          })}
        />
      </Stack.Item>
    </Stack>
  );
};
