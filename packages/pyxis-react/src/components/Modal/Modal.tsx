import { cloneElement, FC, ReactElement } from 'react';
import classNames from 'classnames';
import Header, { HeaderProps } from './Header';
import Footer, { FooterProps } from './Footer';
import Content, { ContentProps } from './Content';

const getBackdropClasses = (isOpen: boolean, className?: string): string => classNames(
  'modal-backdrop',
  className,
  { 'modal-backdrop--show': isOpen },
);

const getModalClasses = (size: Size, isCentered: boolean): string => classNames(
  'modal',
  `modal--${size}`,
  { 'modal--center': isCentered },
);

const mapChildren: MapChildren = (children) => children.map((child) => {
  switch (child.type) {
    case Header:
      return ['header', child];
    case Footer:
      return ['footer', child];
    default:
      return ['content', child];
  }
});

export const Modal: FC<ModalProps> & ModalChildren = ({
  accessibilityDescription,
  children,
  className,
  closeLabel = 'close',
  id,
  isCentered = false,
  isOpen,
  onClose,
  size = 'medium',
}) => {
  const { header, footer, content } = Object.fromEntries(mapChildren(children));
  const headerId = `${id}-header`;
  const footerId = `${id}-footer`;
  const accessibleDescriptionId = `${id}-accessible-description`;
  return (
    <>
      <div
        aria-describedby={accessibilityDescription && accessibleDescriptionId}
        aria-hidden={!isOpen}
        aria-labelledby={headerId}
        aria-modal
        className={getBackdropClasses(isOpen, className)}
        id={id}
        role="dialog"
      >
        {accessibilityDescription && (
          <div className="screen-reader-only" id={accessibleDescriptionId}>
            {accessibilityDescription}
          </div>
        )}
        {onClose && (
          <button
            aria-label={closeLabel}
            className="modal-close"
            data-testid={`${id}-backdrop-close-button`}
            onClick={onClose}
            tabIndex={-1}
          />
        )}
        <div className={getModalClasses(size, isCentered)} data-testid={id}>
          {header
            && cloneElement(header, {
              id: headerId,
              closeLabel,
              onClose,
            })}
          {content}
          {footer && cloneElement(footer, { id: footerId })}
        </div>
      </div>
    </>
  );
};

Modal.Header = Header as ModalChildren['Header'];
Modal.Content = Content;
Modal.Footer = Footer as ModalChildren['Footer'];

export default Modal;

type Size = 'small' | 'medium' | 'large';

export interface ModalProps {
  accessibilityDescription?: string;
  children: ChildrenProps;
  className?: string;
  closeLabel?: string;
  id: string;
  isCentered?: boolean;
  isOpen: boolean;
  onClose?: () => void;
  size?: Size;
}

type ChildrenProps = ReactElement<HeaderProps | FooterProps | ContentProps>[];

type MapChildren = (children: ChildrenProps) => [string, ReactElement][];

interface ModalChildren {
  Header: FC<Omit<HeaderProps, 'id' | 'onClose'>>;
  Content: FC<ContentProps>;
  Footer: FC<Omit<FooterProps, 'id'>>;
}
