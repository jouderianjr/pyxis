import React, { AnchorHTMLAttributes, ButtonHTMLAttributes, FC } from 'react';
import { IconProps } from 'components/Icon';
import classNames from 'classnames';

const getClasses = (loading:boolean, alt:boolean, className?:string):string => classNames(
  'button-card',
  {
    'button-card--loading': loading,
    'button-card--alt': alt,
  }, className,
);

const isAnchor = (props:ButtonCardProps) => (props as CommonAnchorProps).href !== undefined;

const ButtonCardContent:FC<ContentProps> = ({
  children,
  icon: Icon,
  subtitle,
}) => (
  <>
    <span className="button-card__icon">
      {Icon && <Icon size="l" />}
    </span>
    <span className="button-card__wrapper">
      <span className="button-card__title">
        {children}
      </span>
      {subtitle && (
      <span className="button-card__subtitle">
        {subtitle}
      </span>
      )}
    </span>
  </>
);

const ButtonCard:FC<ButtonCardProps> = (props: ButtonCardProps) => {
  const {
    alt = false,
    children,
    className,
    icon,
    id,
    loading = false,
    subtitle,
    tabIndex,
    type = 'button',
    ...restProps
  } = props;

  if (isAnchor(props)) {
    return (
      <a
        className={getClasses(loading, alt, className)}
        data-testid={id}
        id={id}
        tabIndex={loading ? -1 : tabIndex}
        {...restProps as AnchorHTMLAttributes<HTMLAnchorElement>}
      >
        <ButtonCardContent icon={icon} subtitle={subtitle}>
          {children}
        </ButtonCardContent>
      </a>
    );
  }

  return (
    <button
      className={getClasses(loading, alt, className)}
      data-testid={id}
      id={id}
      tabIndex={loading ? -1 : tabIndex}
      type={type as ButtonHTMLAttributes<HTMLButtonElement>['type']}
      {...restProps as ButtonHTMLAttributes<HTMLButtonElement>}
    >
      <ButtonCardContent icon={icon} subtitle={subtitle}>
        {children}
      </ButtonCardContent>
    </button>
  );
};

export default ButtonCard;

interface ContentProps {
  children: string;
  icon: FC<IconProps>;
  subtitle?: string;
}

interface BaseProps {
  alt?: boolean;
  children: string;
  icon: FC<IconProps>;
  loading?: boolean;
  subtitle?: string;
}

type CommonButtonProps = BaseProps & ButtonHTMLAttributes<HTMLButtonElement>;
type CommonAnchorProps = BaseProps & AnchorHTMLAttributes<HTMLAnchorElement>;
export type ButtonCardProps = CommonButtonProps | CommonAnchorProps;
