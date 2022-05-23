import React, {Dispatch, FC, ReactElement, SetStateAction} from "react";
import {IconCheckCircle, IconClose, IconQuestionCircle} from "components/Icon/Icons";
import Button from "components/Button";
import breakpointTokens from '@pyxis/tokens/json/breakpoints.json';
import classNames from "classnames";
import {pascalToKebab} from "commons/utils/string";

const checkIsMobile = ():boolean => window.innerWidth < breakpointTokens.xsmall

const setTooltipClass = (variant?: "brand" | "neutral", alt?:boolean, position?:TooltipPosition) => classNames(
  "tooltip",
  {
    "tooltip--brand": variant === "brand",
    "tooltip--alt": alt,
    [`tooltip--${pascalToKebab(position || "")}`]:position
  }
)

const setBackdropClass = (isVisible:boolean) => classNames(
  "tooltip-backdrop",
  { "tooltip-backdrop--show": isVisible }
)

const PopoverTooltip:FC<PopoverTooltipProps> =
  ({
     variant,
     alt,
     id,
     position,
     hasIcon
  }) => (
  <div className={setTooltipClass(variant, alt, position)} role="tooltip" id={id}>
    { hasIcon && <IconCheckCircle/> }
    Tooltip text
  </div>
)

const BottomSheetTooltip:FC<BottomSheetTooltipProps> = ({id, isVisible, setIsVisible, hasIcon, hasTitle}) => (
  <div className={setBackdropClass(isVisible)} onClick={()=>setIsVisible(false)}>
    <div
      className="tooltip"
      role="dialog"
      id={id}
      aria-describedby="tooltip-desc"
      aria-hidden={!isVisible}
      aria-modal={true}
      aria-labelledby="tooltip-label"
    >
      <header className="tooltip__header">
        {hasTitle && <div className="tooltip__header__title" id="tooltip-label">
          {hasIcon && <IconCheckCircle/>}
          Tooltip title
        </div>}
        <Button
          variant="tertiary"
          className="tooltip__header__close"
          icon={IconClose}
          iconPlacement="only"
          size="medium"
          onClick={()=>setIsVisible(false)}
        >Close</Button>
      </header>
      <div className="tooltip__content" id="tooltip-desc">
        Tooltip text
      </div>
    </div>
  </div>
)

const Tooltip:FC<TooltipProps> =
  ({
     hasBottomSheet = true,
     hasBottomSheetTitle = true,
     id,
     variant = "neutral",
     alt= false,
     position= "right",
     hasIcon= false,
     children
  }) => {
  const [isMobile, setIsMobile] = React.useState<boolean>(checkIsMobile());
  const [isVisible, setIsVisible] = React.useState<boolean>(false);
  const handleResize = () => setIsMobile(checkIsMobile());

  React.useLayoutEffect(
  () => {
      window.addEventListener('resize', handleResize);
      return () => window.removeEventListener('resize', handleResize);
    }, []
  )

  React.useEffect(() => {
    isVisible && isMobile && hasBottomSheet
      ? document.documentElement.classList.add('scroll-locked')
      : document.documentElement.classList.remove('scroll-locked');
  }, [isVisible, isMobile])

  return (
    <div className="tooltip-wrapper">
      {React.cloneElement(
        children,
        {
          "aria-describedby": id,
          onClick: () => setIsVisible(true),
        }
        )}
      {
        isMobile && hasBottomSheet
          ? <BottomSheetTooltip
              id={id}
              hasTitle={hasBottomSheetTitle}
              isVisible={isVisible}
              setIsVisible={setIsVisible}
              hasIcon={hasIcon}
            />
          : !isMobile
            ? <PopoverTooltip
                id={id}
                variant={variant}
                alt={alt}
                position={position}
                hasIcon={hasIcon}
              />
            : null
      }
    </div>
  )
}

export const Tooltips = () => {
  return (
    <>
      <Tooltip id="tooltip-id-top" position={"top"}>
        <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost">Tooltip</Button>
      </Tooltip>
      <Tooltip id="tooltip-id-top-right" position={"topRight"}>
        <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost">Tooltip</Button>
      </Tooltip>
      <Tooltip id="tooltip-id" position={"topLeft"}>
        <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost">Tooltip</Button>
      </Tooltip>
      <Tooltip id="tooltip-id-right" position={"right"}>
        <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost">Tooltip</Button>
      </Tooltip>
      <Tooltip id="tooltip-id-left" position={"left"}>
        <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost">Tooltip</Button>
      </Tooltip>
      <Tooltip id="tooltip-id-bottom-right" position={"bottomRight"}>
        <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost">Tooltip</Button>
      </Tooltip>
      <Tooltip id="tooltip-id-bottom-left" position={"bottomLeft"}>
        <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost">Tooltip</Button>
      </Tooltip>
      <Tooltip id="tooltip-id-bottom" position={"bottom"}>
        <Button icon={IconQuestionCircle} iconPlacement="only" variant="ghost">Tooltip</Button>
      </Tooltip>
    </>
)
}

type TooltipPosition = "top" | "topLeft" | "topRight" | "left" | "bottom" | "bottomLeft" | "bottomRight" | "right";

export interface TooltipProps {
  alt?:boolean;
  children: ReactElement;
  hasBottomSheet?:boolean;
  hasBottomSheetTitle?:boolean;
  hasIcon?:boolean;
  hasMaxWidth?:boolean;
  id:string;
  position?: TooltipPosition;
  variant?:"neutral" | "brand";
}

interface PopoverTooltipProps {
  alt?:boolean;
  hasIcon:boolean;
  id:string;
  position: TooltipPosition;
  variant:"neutral" | "brand";
}

interface BottomSheetTooltipProps {
  hasIcon:boolean;
  hasTitle:boolean;
  id:string;
  isVisible:boolean;
  setIsVisible: Dispatch<SetStateAction<boolean>>;
}

export default Tooltip;
