import React, {FC, useEffect, useState} from "react";
import classNames from "classnames";
import Button from "components/Button";
import {IconCar, IconClose} from "components/Icon/Icons";
import Badge from "../Badge/Badge";

const getBackdropClasses = (show: boolean): string => classNames(
  "modal-backdrop",
  {
    ["modal-backdrop--show"]: show,
  },
);

const getModalClasses = (size: ModalSize, isCentered: boolean): string => classNames(
  'modal',
  `modal--${size}`,
  { 'modal--center': isCentered }
);

const getHeaderClasses = (isSticky: boolean) => classNames(
  'modal__header',
  {
    'modal__header--sticky': isSticky,
  },
);

const getHeaderWrapperClasses = (isCustom: boolean) => classNames(
  'modal__header__wrapper',
  {
    'modal__header__wrapper--custom': isCustom,
  },
);

const getFooterClasses = (isSticky:boolean, alt:boolean, isCustom:boolean) => classNames(
  'modal__footer',
  {
    'modal__footer--sticky': isSticky,
    'modal__footer--alt': alt,
    'modal__footer--custom': isCustom,
  },
);

const getFooterButtonsClasses = (fullWidth:boolean) => classNames(
  'modal__footer__buttons',
  {
    'modal__footer__buttons--full-width': fullWidth,
  },
);

const Modal: FC<ModalProps> = ({
  accessibilityDescription,
  altFooter = false,
  customFooter,
  customHeader,
  footerText,
  fullWidthButton = false,
  isCentered = false,
  shortContent= false,
  size = 'medium',
  stickyFooter = false,
  stickyHeader = false,
  withBadge = false,
  withoutCloseButton = false,
  withIcon = false,
}) => {
  const [isOpened, setIsOpened] = useState(false);

  useEffect(() => {
    isOpened
      ? document.documentElement.classList.add('scroll-locked')
      : document.documentElement.classList.remove('scroll-locked');
  }, [isOpened])

  return (
    <>
      <Button size="large" onClick={() => setIsOpened(true)}>Open Modal</Button>
      <div
        aria-describedby={accessibilityDescription && "id-accessible-description"}
        aria-hidden={!isOpened}
        aria-modal={true}
        aria-labelledby='modal-label'
        className={getBackdropClasses(isOpened)}
        role="dialog"
      >
        <div id="modal-description" className="screen-reader-only">{accessibilityDescription}</div>
        {!withoutCloseButton && <div className="modal-close" onClick={() => setIsOpened(false)}/>}
        <div className={getModalClasses(size, isCentered)}>
          <header className={getHeaderClasses(stickyHeader)}>
            <div className={getHeaderWrapperClasses(!!customHeader)}>
              {customHeader || (
                <>
                  {withBadge &&
                    <div className="modal__header__badge">
                      <Badge variant="brand">Badge</Badge>
                    </div>
                  }
                  {withIcon && <IconCar className="c-brand-base" size="l"/>}
                  <h3 className="modal__header__title" id="modal-label">How to recover commercial MQs</h3>
                </>
              )}
            </div>
            {!withoutCloseButton && <Button icon={IconClose} iconPlacement="only" variant="tertiary" size="medium" onClick={() => setIsOpened(false)}>Close</Button>}
          </header>
          <div className="modal__content">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus. Integer scelerisque mi at blandit vestibulum. Vivamus nec nibh id lacus lacinia facilisis vel nec felis.
            {!shortContent &&
              <>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus. Integer
                scelerisque mi at blandit vestibulum. Vivamus nec nibh id lacus lacinia facilisis vel nec felis. Duis
                rhoncus rutrum volutpat. Quisque at pulvinar enim. Vestibulum ut posuere erat. Quisque cursus ut odio
                vel faucibus. Duis semper venenatis finibus. Morbi iaculis ligula at justo lobortis vulputate. Duis
                vestibulum neque at neque fringilla malesuada. Nulla vitae nunc sed lectus varius facilisis in eu nisi.
                Aliquam erat volutpat. Phasellus sapien elit, suscipit id eleifend sed, posuere ac nulla. Duis volutpat,
                mauris sit amet tincidunt ornare, nunc erat semper ex, quis rhoncus eros nulla et metus. Vestibulum eu
                egestas felis, quis porta lectus.
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultrices libero ac semper cursus. Integer
                scelerisque mi at blandit vestibulum. Vivamus nec nibh id lacus lacinia facilisis vel nec felis. Duis
                rhoncus rutrum volutpat. Quisque at pulvinar enim. Vestibulum ut posuere erat. Quisque cursus ut odio
                vel faucibus. Duis semper venenatis finibus. Morbi iaculis ligula at justo lobortis vulputate. Duis
                vestibulum neque at neque fringilla malesuada. Nulla vitae nunc sed lectus varius facilisis in eu nisi.
                Aliquam erat volutpat. Phasellus sapien elit, suscipit id eleifend sed, posuere ac nulla. Duis volutpat,
                mauris sit amet tincidunt ornare, nunc erat semper ex, quis rhoncus eros nulla et metus. Vestibulum eu
                egestas felis, quis porta lectus.
              </>
            }
            </div>
          <footer className={getFooterClasses(stickyFooter, altFooter, !!customFooter)}>
            {customFooter ||
              <>
                {footerText && <div className="modal__footer__text">{footerText}</div>}
                <div className={getFooterButtonsClasses(fullWidthButton)}>
                  <Button variant="secondary" size="large">Secondary</Button>
                  {!withoutCloseButton && <Button size="large">Primary</Button>}
                  {withoutCloseButton && <Button size="large" onClick={() => setIsOpened(false)}>Close</Button>}
                </div>
              </>
            }
          </footer>
        </div>
      </div>
    </>
  )
}

type ModalSize = 'small' | 'medium' | 'large';

interface ModalProps {
  accessibilityDescription?: string;
  altFooter?: boolean;
  customFooter?: React.ReactNode;
  customHeader?: React.ReactNode;
  footerText?: string;
  fullWidthButton?: boolean;
  isCentered?: boolean;
  shortContent?: boolean;
  size?: ModalSize;
  stickyFooter?: boolean;
  stickyHeader?: boolean;
  withBadge?: boolean;
  withoutCloseButton?: boolean;
  withIcon?: boolean;
}


export default Modal;
