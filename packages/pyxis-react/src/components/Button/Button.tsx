import React, { AnchorHTMLAttributes, ButtonHTMLAttributes, FC } from 'react';
import classNames from 'classnames';
import { Size as IconSize } from 'components/Icon';
import {
  ButtonContentProps,
  ButtonFC, IconPlacement, Size, isAnchor,
} from './types';

const getIconSize = (buttonSize: Size): IconSize => {
  switch (buttonSize) {
    case 'huge':
      return 'l';
    case 'large':
      return 'm';
    case 'medium':
    case 'small':
    default:
      return 's';
  }
};

const ButtonContent:FC<ButtonContentProps> = ({
  icon: Icon, children, iconPlacement, size,
}) => (
  Icon ? (
    <>
      { iconPlacement === 'prepend' && <Icon size={getIconSize(size as Size)} /> }
      { iconPlacement === 'only' && <Icon description={children} size={getIconSize(size as Size)} /> }
      { iconPlacement !== 'only' && children}
      { iconPlacement === 'append' && <Icon size={getIconSize(size as Size)} /> }
    </>
  )
    : <>{children}</>
);

const Button:ButtonFC = (props) => {
  const {
    alt,
    children,
    className,
    contentWidth,
    icon,
    iconPlacement = 'prepend',
    id,
    loading,
    shadow,
    size = 'medium',
    type = 'button',
    variant = 'primary',
    tabIndex,
    ...restProps
  } = props;

  const classList = classNames(
    'button',
    `button--${variant}`,
    `button--${size}`,
    className,
    {
      'button--shadow': shadow,
      'button--content-width': contentWidth,
      'button--loading': loading,
      'button--alt': alt,
      'button--prepend-icon': icon && iconPlacement === 'prepend',
      'button--append-icon': icon && iconPlacement === 'append',
      'button--icon-only': icon && iconPlacement === 'only',
    },
  );

  const Content = () => (
    <ButtonContent
      icon={icon}
      iconPlacement={iconPlacement as IconPlacement}
      size={size as Size}
    >
      {children}
    </ButtonContent>
  );

  if (isAnchor(props)) {
    return (
      <a
        className={classList}
        data-testid={id}
        id={id}
        tabIndex={loading ? -1 : tabIndex}
        {...restProps as AnchorHTMLAttributes<HTMLAnchorElement>}
      >
        <Content />
      </a>
    );
  }

  return (
    <button
      className={classList}
      data-testid={id}
      id={id}
      tabIndex={loading ? -1 : tabIndex}
      type={type as ButtonHTMLAttributes<HTMLButtonElement>['type']}
      {...restProps as ButtonHTMLAttributes<HTMLButtonElement>}
    >
      <Content />
    </button>
  );
};

export default Button;
