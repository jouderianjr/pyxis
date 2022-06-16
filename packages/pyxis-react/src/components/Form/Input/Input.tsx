import React, { FC, InputHTMLAttributes } from 'react';
import classNames from 'classnames';
import Addon, { StringType, Type as AddonType, getAddonStringType } from './Addon';

const getClasses = (
  disabled: boolean,
  error: boolean,
  className?: string,
  addonPlacement?: AddonPlacement,
  addonType?: StringType,
): string => classNames(
  'form-field',
  {
    'form-field--disabled': disabled,
    'form-field--error': error,
    [`form-field--with-${addonPlacement}-${addonType}`]: addonType,
  },
  className,
);

const getAriaDescribedBy = (addonId?: string, hintId?: string) => [addonId, hintId].join(' ');

const getInputClasses = (size: Size):string => classNames(
  'form-field__text',
  { 'form-field__text--small': size === 'small' },
);
const Input: FC<InputProps> = ({
  addon,
  addonPlacement = 'prepend',
  className,
  disabled = false,
  errorId,
  hasError = false,
  hintId,
  id,
  size = 'medium',
  type = 'text',
  ...restProps
}) => {
  const addonType = addon ? getAddonStringType(addon) : undefined;
  const addonId = addon ? `${id}-addon` : '';

  return (
    <div className={getClasses(disabled, hasError, className, addonPlacement, addonType)} data-testid={`${id}-wrapper`}>
      <label className="form-field__wrapper">
        {addon && addonPlacement === 'prepend' && <Addon addon={addon} id={addonId} />}
        <input
          aria-describedby={getAriaDescribedBy(addonId, hintId)}
          aria-errormessage={errorId}
          aria-invalid={hasError}
          className={getInputClasses(size)}
          data-testid={id}
          disabled={disabled}
          id={id}
          type={type}
          {...restProps}
        />
        {addon && addonPlacement === 'append' && <Addon addon={addon} id={addonId} />}
      </label>
    </div>
  );
};

export default Input;

type Size = 'medium' | 'small';
type AddonPlacement = 'append' | 'prepend';
type Type = 'email' | 'number' | 'password' | 'search' | 'tel' | 'text' | 'url';

export interface InputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'size' | 'type'>{
  addon?: AddonType;
  addonPlacement?: AddonPlacement
  errorId?: string;
  hasError?: boolean;
  hintId?: string;
  size?: Size;
  type?: Type;
}
