type TraitProps = {
  fluff: JSX.Element;
  title: string;
  img: string;
};

type TraitFluffProps = {
  bar?: JSX.Element;
  desc: string;
};

type DesiresTraitFluffProps = TraitFluffProps & {
  active: boolean;
  desires: string[];
};

type TraitBarProps = {
  maxValue?: number;
  minValue?: number;
  value: number;
  label: string;
};

type Style = {
  value: number;
  min: number;
  max: number;
};

type Sanity = {
  value: number;
  max: number;
};

type Desires = {
  resting: boolean;
  desires: string[];
  value: number;
};

type RighteousLife = {
  'present': boolean;
  'value': number;
};

type SanityData = {
  style: Style;
  sanity: Sanity;
  desires: Desires;
  righteous: RighteousLife;
  insight: number;
};
