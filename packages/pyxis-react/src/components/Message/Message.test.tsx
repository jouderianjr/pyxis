import { fireEvent, render, screen } from '@testing-library/react';
import React from 'react';
import Message, { Variant } from './Message';
import { IconCalendar } from '../Icon/Icons';

const variants:Variant[] = ['brand', 'alert', 'success', 'error', 'ghost'];

const iconTestIds = {
  brand: 'icon-message-id-thumb-up-icon',
  success: 'icon-message-id-check-circle-icon',
  alert: 'icon-message-id-alert-icon',
  error: 'icon-message-id-exclamation-circle-icon',
};

const onCloseFn = jest.fn();

describe('Message component', () => {
  test('it should mount', () => {
    render(<Message id="message-id">Message</Message>);
    const message = screen.getByTestId('message-id');
    expect(message).toBeInTheDocument();
    expect(message).toHaveClass('message');
  });

  variants.forEach(
    (variant) => describe(`Variant ${variant}`, () => {
      test('should have the proper class', () => {
        render(<Message id="message-id" variant={variant}>Message</Message>);
        const message = screen.getByTestId('message-id');
        expect(message).toHaveClass(`message--${variant}`);
      });
      test('should have the correct role', () => {
        render(<Message id="message-id" variant={variant}>Message</Message>);
        const message = screen.getByTestId('message-id');
        const expectedRole = variant === 'error' ? 'alert' : 'status';
        expect(message).toHaveAttribute('role', expectedRole);
      });
      test('should have the correct icon', () => {
        render(<Message id="message-id" variant={variant}>Message</Message>);
        const icon = screen.getByTestId(iconTestIds[variant] || 'icon-message-id-info-circle-icon');
        expect(icon).toBeInTheDocument();
      });
    }),
  );

  test('it could have a colored background', () => {
    render(<Message hasColoredBackground id="message-id" variant="brand">Message</Message>);
    const message = screen.getByTestId('message-id');
    expect(message).toHaveClass('message--with-background-color');
  });

  test('it could have a title', () => {
    const messageTitle = 'Message title';
    render(<Message hasColoredBackground id="message-id" title={messageTitle}>Message</Message>);
    const message = screen.getByTestId('message-id');
    const title = message.querySelector('div.message__title');
    expect(title).toBeInTheDocument();
    expect(title).toHaveTextContent(messageTitle);
  });

  describe('when is dismissible', () => {
    test('it has the closing icon and the aria-label for it', () => {
      const id = 'message-id';
      render(<Message id={id} onClose={onCloseFn} onCloseAccessibleLabel="accessible-label">Message</Message>);
      const message = screen.getByTestId(id);
      const close = message.querySelector('button.message__close');
      expect(close).toBeInTheDocument();
      expect(close).toHaveAttribute('aria-label', 'accessible-label');
    });

    test('it calls the closing function on click', () => {
      const id = 'message-id';
      render(<Message id={id} onClose={onCloseFn} onCloseAccessibleLabel="accessible-label">Message</Message>);
      const message = screen.getByTestId(id);
      const close = message.getElementsByClassName('message__close')[0];
      fireEvent.click(close);
      expect(onCloseFn).toHaveBeenCalled();
    });
  });
});
