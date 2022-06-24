import React, { FC, ReactElement, ReactNode } from 'react';
import classNames from 'classnames';
import {
  IconAlert, IconCheckCircle, IconClose, IconExclamationCircle, IconInfoCircle, IconThumbUp,
} from 'components/Icon/Icons';
import { IconProps } from 'components/Icon';

const getClasses = (withBackground:boolean, variant?: string, className?: string):string => classNames(
  'message',
  {
    [`message--${variant}`]: variant,
    'message--with-background-color': withBackground && variant,
  },
  className,
);

const getIconId = (id?:string, iconName?:string):string | undefined => (
  id ? ['icon', id, iconName].filter(Boolean).join('-') : undefined
);

const setIcon = (variant?: Variant, id?:string):ReactElement<IconProps> => {
  switch (variant) {
    case 'brand':
      return <IconThumbUp id={getIconId(id, 'thumb-up-icon')} />;
    case 'success':
      return <IconCheckCircle id={getIconId(id, 'check-circle-icon')} />;
    case 'alert':
      return <IconAlert id={getIconId(id, 'alert-icon')} />;
    case 'error':
      return <IconExclamationCircle id={getIconId(id, 'exclamation-circle-icon')} />;
    default:
      return <IconInfoCircle id={getIconId(id, 'info-circle-icon')} />;
  }
};

const Message: FC<MessageProps> = ({
  children,
  className,
  customIcon: Icon,
  hasColoredBackground = false,
  id,
  onClose,
  onCloseAccessibleLabel,
  title,
  variant,
}) => {
  const isGhost = variant === 'ghost';
  return (
    <div
      className={getClasses(hasColoredBackground, variant, className)}
      data-testid={id}
      id={id}
      role={variant === 'error' ? 'alert' : 'status'}
    >
      <div className="message__icon">
        {Icon ? <Icon id={getIconId(id, Icon.displayName)} /> : setIcon(variant, id)}
      </div>
      <div className="message__content-wrapper">
        {title && !isGhost && <div className="message__title">{title}</div>}
        <div className="message__text">{children}</div>
      </div>
      {!isGhost && onClose
        && (
        <button aria-label={onCloseAccessibleLabel} className="message__close" onClick={onClose}>
          <IconClose size="s" />
        </button>
        )}
    </div>
  );
};

export default Message;

export type Variant = 'brand' | 'alert' | 'success' | 'error' | 'ghost';

export interface MessageProps {
  className?: string;
  children: ReactNode;
  customIcon?: FC<IconProps>;
  id?: string;
  onClose?: () => void;
  onCloseAccessibleLabel?: string;
  title?: string;
  variant?: Variant;
  hasColoredBackground?: boolean;
}
