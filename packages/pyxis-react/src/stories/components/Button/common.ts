import {IconPlacement, Size, Variant} from "components/Button/types";

export const buttonVariant:Variant[] = ['primary', 'secondary', 'tertiary', 'brand', 'ghost'];
export const buttonSizes:Size[] = ['huge', 'large', 'medium', 'small'];
export const buttonIconPlacements:IconPlacement[] = ['prepend', 'append', 'only'];

export const variantUsage = (variant: Variant):string => {
  switch (variant) {
    case 'primary':
      return 'Default value.';
    default:
      return '-';
  }
}

export const sizeUsage = (size: Size):string => {
  switch (size) {
    case 'huge':
      return 'Is only allowed with `primary` variant.';
    case 'medium':
      return 'Default value.';
    default:
      return '-';
  }
}

export const iconPlacementUsage = (placement: IconPlacement):string => {
  switch (placement) {
    case 'only':
      return 'Is not allowed with `small` size.';
    case 'prepend':
      return 'Default value.';
    default:
      return '-';
  }
}
