import React, {useState} from 'react';
import {ComponentMeta, ComponentStory} from '@storybook/react';
import Modal, {ModalProps} from "components/Modal";
import Button from "components/Button";
import {HeaderDefault, StickyHeader} from "./Header/ModalHeader.stories";
import {FooterDefault, StickyFooter} from "./Footer/ModalFooter.stories";

const {Header, Footer, Content} = Modal;

export default {
  title: 'Components - Display/Modal/All Stories',
  component: Modal,
  subcomponents: {Header, Footer, Content},
  argTypes: {
    onClose: { action: 'Close clicked' }
  }
} as ComponentMeta<typeof Modal>;

const modalContent = <p className="text-m-book">
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eget pharetra elit. Nam blandit efficitur fringilla.
  Quisque sollicitudin diam augue, et finibus purus dapibus varius. Nam dignissim sit amet tortor ac iaculis.
  Nunc tristique nisl massa, eget porta ligula porttitor sed. Praesent eleifend risus vel justo ullamcorper,
  bibendum ornare purus efficitur. Suspendisse sed velit leo. Nullam fringilla ligula magna,
  nec mollis metus imperdiet quis. Proin massa nisl, aliquam non rhoncus sit amet, lacinia posuere tortor.
</p>

const Template:ComponentStory<typeof Modal> = (args:ModalProps) => (
  <Modal {...args}>
    <Modal.Header {...HeaderDefault.args}/>
    <Modal.Content>{modalContent}</Modal.Content>
    <Modal.Footer {...FooterDefault.args}/>
  </Modal>
)

const NonClosableTemplate:ComponentStory<typeof Modal> = (args:ModalProps) => (
  <Modal {...args} onClose={undefined}>
    <Modal.Header {...HeaderDefault.args}/>
    <Modal.Content>{modalContent}</Modal.Content>
    <Modal.Footer {...FooterDefault.args}/>
  </Modal>
)

const DefaultTemplate:ComponentStory<typeof Modal> = (args:ModalProps) => {
  const [isOpen, setIsOpen] = useState(false);
  return(
    <>
      <Button onClick={()=> setIsOpen(true)}>Open</Button>
      <Modal {...args} isOpen={isOpen} onClose={()=>setIsOpen(false)}>
        <Modal.Header {...HeaderDefault.args}/>
        <Modal.Content>{modalContent}</Modal.Content>
        <Modal.Footer {...FooterDefault.args}/>
      </Modal>
    </>
)}

const StickyTemplate:ComponentStory<typeof Modal> = (args:ModalProps) => (
  <Modal {...args}>
    <Modal.Header {...StickyHeader.args}/>
    <Modal.Content>{modalContent}{modalContent}{modalContent}{modalContent}</Modal.Content>
    <Modal.Footer {...StickyFooter.args}/>
  </Modal>
)

export const Default = DefaultTemplate.bind({});
Default.args = {
  id: "modal-default",
}

export const DefaultOnMobile = Template.bind({});
DefaultOnMobile.args = {
  id: "modal-default-on-mobile",
  isOpen: true,
}
DefaultOnMobile.parameters = {
  viewport: { defaultViewport: "xxsmall" },
  docs: { inlineStories: false }
}

export const SizeLarge = Template.bind({});
SizeLarge.args = {
  id: "modal-large",
  isOpen: true,
  size: "large",
}
SizeLarge.parameters = {
  docs: { inlineStories: false }
}

export const SizeSmall = Template.bind({});
SizeSmall.args = {
  id: "modal-small",
  isOpen: true,
  size: "small",
}
SizeSmall.parameters = {
  docs: { inlineStories: false }
}

export const CenteredModal = Template.bind({});
CenteredModal.args = {
  id: "modal-center",
  isOpen: true,
  isCentered: true,
}
CenteredModal.parameters = {
  docs: { inlineStories: false }
}

export const NonClosableModal = NonClosableTemplate.bind({});
NonClosableModal.args = {
  id: "modal-non-closable",
  isOpen: true,
  onClose: undefined
}
NonClosableModal.parameters = {
  docs: { inlineStories: false }
}

export const WithStickyHeaderAndFooter = StickyTemplate.bind({});
WithStickyHeaderAndFooter.args = {
  id: "modal-sticky",
  isOpen: true,
  size: "small",
}
WithStickyHeaderAndFooter.parameters = {
  docs: { inlineStories: false }
}
