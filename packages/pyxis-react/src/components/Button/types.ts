import {
  AnchorHTMLAttributes, ButtonHTMLAttributes, FC, ReactElement,
} from 'react';
import { IconProps } from 'components/Icon';

type Size
  = 'huge'
  | 'large'
  | 'medium'
  | 'small'

type Variant
  = 'primary'
  | 'secondary'
  | 'tertiary'
  | 'brand'
  | 'ghost'

type IconPlacement
  = 'prepend'
  | 'append'
  | 'only'

type SizeCheck<S, V> =
  S extends 'huge'
    ? V extends 'primary'
      ? S
      : ['size `huge` can only be used with `primary` variant']
    : S

type ShadowCheck<V> =
  V extends 'primary'
    ? boolean
    : V extends 'brand'
      ? boolean
      : 'shadow can only be used with `primary` or `brand` variant'

type LoadingCheck<S, V> =
  S extends 'small'
    ? 'loading cannot be used with `small` size'
    : V extends 'ghost'
      ? 'loading cannot be used with `ghost` variant'
      : boolean

type ContentWidthCheck<V, I> =
  V extends 'ghost'
    ? 'contentWidth cannot be used with `ghost` variant'
    : I extends 'only'
      ? 'contentWidth cannot be used with iconPlacement `only`'
      : boolean

type IconPlacementCheck<I, S> =
  S extends 'small'
    ? 'iconPlacement `only` cannot be used with small size'
    : I

interface BaseProps<S extends Size, V extends Variant, I extends IconPlacement> {
  alt?: boolean;
  children: string;
  contentWidth?: ContentWidthCheck<V, I>
  icon?: FC<IconProps>
  iconPlacement?: IconPlacementCheck<I, S>;
  loading?: LoadingCheck<S, V>;
  shadow?: ShadowCheck<V>;
  size?: SizeCheck<S, V>;
  variant?: V;
}

type CommonButtonProps<S extends Size, V extends Variant, I extends IconPlacement> =
  BaseProps<S, V, I> & ButtonHTMLAttributes<HTMLButtonElement>

type CommonAnchorProps<S extends Size, V extends Variant, I extends IconPlacement> =
  BaseProps<S, V, I> & AnchorHTMLAttributes<HTMLAnchorElement>

type ButtonProps<S extends Size, V extends Variant, I extends IconPlacement> =
  CommonButtonProps<S, V, I> | CommonAnchorProps<S, V, I>;

type ButtonFC = <S extends Size, V extends Variant, I extends IconPlacement>(props: ButtonProps<S, V, I>) =>
  ReactElement<ButtonProps<S, V, I>>;

interface ButtonContentProps {
  icon?: FC<IconProps>,
  children: string,
  iconPlacement: IconPlacement,
  size: Size,
}

const isAnchor = <S extends Size, V extends Variant, I extends IconPlacement>(
  props:CommonButtonProps<S, V, I> | CommonAnchorProps<S, V, I>,
): props is CommonAnchorProps<S, V, I> => (props as CommonAnchorProps<S, V, I>).href !== undefined;

export { isAnchor };

export type {
  ButtonFC,
  IconPlacement,
  ButtonProps,
  Size,
  Variant,
  ButtonContentProps,
};
