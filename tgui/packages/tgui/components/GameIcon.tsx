type GameIconProps = {
  html: string;
  className?: string;
  style?: any;
  title?: string;
  key?: any;
};

export const GameIcon = (props: GameIconProps) => {
  const { html, className, style, key } = props;
  const iconSrc = html.match('src=["\'](.*)["\']')![1];

  return (
    <img
      key={key}
      {...props}
      className={`game-icon ${className || ''}`}
      src={iconSrc}
      style={{ '-ms-interpolation-mode': 'nearest-neighbor', ...style }}
    />
  );
};
