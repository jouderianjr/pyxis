import { FC, ReactElement, ReactNode } from 'react';
import Button from 'components/Button';
import classNames from 'classnames';
import { IconClose } from 'components/Icon/Icons';
import { IconProps } from 'components/Icon';
import { BadgeProps } from 'components/Badge';

const getClasses = (isSticky: boolean): string => classNames('modal__header', { 'modal__header--sticky': isSticky });

const getWrapperClasses = (isCustom: boolean) => classNames('modal__header__wrapper', {
  'modal__header__wrapper--custom': isCustom,
});
export const Header: FC<HeaderProps> = ({
  badge,
  children,
  closeLabel = 'close',
  icon,
  id,
  isSticky = false,
  onClose,
  title,
}) => (
  <header className={getClasses(isSticky)} id={id}>
    <div
      className={getWrapperClasses(!!children)}
      data-testid={`${id}-wrapper`}
    >
      {children || (
        <>
          {badge && <div className="modal__header__badge">{badge}</div>}
          {icon}
          {title && <h3 className="modal__header__title">{title}</h3>}
        </>
      )}
    </div>
    {onClose && (
      <Button
        icon={IconClose}
        iconPlacement="only"
        onClick={onClose}
        size="medium"
        variant="tertiary"
      >
        {closeLabel}
      </Button>
    )}
  </header>
);

export default Header;

export interface HeaderProps {
  badge?: ReactElement<BadgeProps>;
  children?: ReactNode;
  closeLabel?: string;
  icon?: ReactElement<IconProps>;
  id: string;
  isSticky?: boolean;
  onClose?: () => void;
  title?: string;
}
