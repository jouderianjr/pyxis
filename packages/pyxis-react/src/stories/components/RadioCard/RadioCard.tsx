import React, {FC} from "react";
import classNames from "classnames";
import placeholder from "stories/assets/placeholder.svg"
import {IconPrimaLogo} from "components/Icon/Icons";

// TODO: remove this implementation when radioCard will be implemented in pyxis-react
// Non-exhaustive implementation, made for testing purposes only.

const setClasses = (isChecked: boolean, isLarge:boolean, error:boolean, disabled:boolean):string => classNames(
  "form-card",
  {
    "form-card--large": isLarge,
    "form-card--checked": isChecked,
    "form-card--error": error,
    "form-card--disabled": disabled
  }
)

const RadioCard: FC<RadioProps> =
  ({
    addon= false,
    checked = false,
    disabled = false,
    error = false,
    hasTitle = true,
    hasText = true,
    isLarge = false,
    name,
    onChange= () => {},
    priceAddon= false
  }) => (
    <label className={setClasses(checked, isLarge, error, disabled)}>
      {isLarge && <span className="form-card__addon">
        <img src={placeholder} width={70} height={70} alt=""/>
      </span>}
      {addon && <span className="form-card__addon form-card__addon--with-icon">
        <IconPrimaLogo size={"l"}/>
      </span>}
      <span className="form-card__content-wrapper">
        {hasTitle && <span className="form-card__title">Title card</span>}
        {hasText && <span className="form-card__text">Text description</span>}
      </span>
      {priceAddon && <span className="form-card__addon">€ 1.000,00</span>}
      <input
        type="radio"
        name={name}
        className="form-control__radio"
        checked={checked}
        disabled={disabled}
        onChange={onChange}
      />
    </label>
);

export const RadioCardGroup: FC<RadioProps> =
  ({
     error= false,
     ...props
  }) => {
    const [activeIndex, setActiveIndex] = React.useState(0);
    return (
      <div className="form-item">
        <label className="form-label" id="my-label-id">Label</label>
        <div
          className="form-card-group"
          role="radiogroup"
          aria-labelledby="my-label-id"
          aria-describedby={error ? "error-id" : ""}
        >
          <RadioCard error={error} {...props} checked={activeIndex === 0} onChange={() => setActiveIndex(0)}/>
          <RadioCard error={error} {...props} checked={activeIndex === 1} onChange={() => setActiveIndex(1)} />
          {error && <div className="form-control-group__error-message" id="error-id">Error message</div>}
        </div>
      </div>
    )
  }

interface RadioProps {
  addon?: boolean;
  checked?: boolean;
  disabled?: boolean;
  error?: boolean;
  hasTitle?: boolean;
  hasText?: boolean;
  isLarge?: boolean;
  name: string;
  onChange?: () => void;
  priceAddon?: boolean;
}

export default RadioCard;