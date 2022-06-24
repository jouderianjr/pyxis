import { FC, ReactNode } from 'react';
import classNames from 'classnames';

const getClasses = (isSticky: boolean, alt: boolean): string => classNames('modal__footer', {
  'modal__footer--alt': alt,
  'modal__footer--sticky': isSticky,
});

const getButtonClasses = (hasFullWidthButtons: boolean) => classNames('modal__footer__buttons', {
  'modal__footer__buttons--full-width': hasFullWidthButtons,
});

const Footer: FC<FooterProps> = ({
  alt = false,
  buttons,
  children,
  hasFullWidthButtons = false,
  id,
  isSticky = false,
  text,
}) => (
  <footer className={getClasses(isSticky, alt)} id={id}>
    {children || (
      <>
        {text && (
        <div className="modal__footer__text" data-testid={`${id}-text`}>
          {text}
        </div>
        )}
        <div
          className={getButtonClasses(hasFullWidthButtons)}
          data-testid={`${id}-buttons`}
        >
          {buttons}
        </div>
      </>
    )}
  </footer>
);

export default Footer;

export interface FooterProps {
  alt?: boolean;
  buttons?: ReactNode;
  children?: ReactNode;
  hasFullWidthButtons?: boolean;
  id: string;
  isSticky?: boolean;
  text?: string;
}
