import React, {FC} from "react";
import classNames from "classnames";

// TODO: remove this implementation when radio will be implemented in pyxis-react
// Non-exhaustive implementation, made for testing purposes only.

const getClasses = (disabled:boolean, error:boolean):string => classNames(
  'form-control',
  {
    'form-control--disabled': disabled,
    'form-control--error': error
  })

const Radio: FC<RadioProps> = (
  {
    checked = false,
    disabled = false,
    error = false,
    name,
    onChange= () => {}
  }) =>
  <label className={getClasses(disabled, error)}>
    <input
      type="radio"
      name={name}
      className="form-control__radio"
      disabled={disabled}
      checked={checked}
      onChange={onChange}
    />
    <span className="form-control__text">Option</span>
  </label>

const getGroupClasses = (layout: LayoutOptions):string => classNames(
  "form-control-group",
  {
    "form-control-group--column": layout === 'vertical',
  }
)

export const RadioGroup: FC<RadioGroupProps> =
  ({name, disabled= false, error= false, hint = false, layout = "horizontal"}) => {
  const [activeIndex, setActiveIndex] = React.useState(0);
  return (
    <div className="form-item">
      <label className="form-label" id="my-label-id">Label</label>
      <div className="form-item__wrapper">
        <div
          className={getGroupClasses(layout)}
          role="radiogroup"
          aria-labelledby="my-label-id"
          aria-describedby={error ? "error-id" : hint ? "hint-id" : ""}
        >
          <Radio name={name} disabled={disabled} error={error} checked={activeIndex === 0}
                 onChange={() => setActiveIndex(0)}/>
          <Radio name={name} disabled={disabled} error={error} checked={activeIndex === 1}
                 onChange={() => setActiveIndex(1)}/>
        </div>
        {error && <div className="form-item__error-message" id="error-id">Error message</div>}
        {hint && !error && <div className="form-item__hint" id="hint-id">Hint</div>}
      </div>
    </div>
  )
}

type LayoutOptions = "horizontal" | "vertical";

interface RadioProps {
  checked?: boolean;
  disabled?: boolean;
  error?: boolean;
  name: string;
  onChange?: () => void;
}

interface RadioGroupProps extends RadioProps {
  layout?: LayoutOptions;
  hint?: boolean;
}

export default Radio;