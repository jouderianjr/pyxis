import React, { FC } from 'react';
import classNames from 'classnames';
import { pascalToKebab } from 'commons/utils/string';

const getClasses = (alt:boolean, variant?:Variant, className?:string):string => classNames(
  'badge',
  {
    [`badge--${variant && pascalToKebab(variant)}`]: variant,
    'badge--alt': alt || variant === 'ghost',
  },
  className,
);

const Badge: FC<BadgeProps> = ({
  alt = false,
  children,
  className,
  id,
  variant,
}) => (
  <span className={getClasses(alt, variant, className)} data-testid={id} id={id}>{children}</span>
);

export default Badge;

export type Variant = 'brand' | 'action' | 'error' | 'success' | 'alert' | 'neutralGradient' | 'brandGradient' | 'ghost';

export interface BadgeProps {
  alt?: boolean;
  children: string;
  className?: string;
  id?: string;
  variant?: Variant;
}
