import React, { FC } from 'react';
import classNames from 'classnames';
import { IconProps } from './types';

const getClasses = (size: string, alt:boolean, className?: string, boxedVariant?: string): string => classNames(
  'icon',
  `icon--size-${size}`,
  className,
  { 'icon--boxed': boxedVariant || alt },
  { 'icon--alt': alt },
  { [`icon--${boxedVariant}`]: boxedVariant },
);

const Icon: FC<IconProps> = ({
  alt = false,
  className,
  description,
  id,
  boxedVariant,
  size = 'm',
  children,
}) => (
  <div
    aria-hidden={!description}
    aria-label={description}
    className={getClasses(size, alt, className, boxedVariant)}
    data-testid={id}
    id={id}
    role={description && 'img'}
  >
    {children}
  </div>
);

export default Icon;
