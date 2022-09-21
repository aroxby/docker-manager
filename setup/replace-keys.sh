#!/bin/sh -e
TARGET_USERS="alpine docker-manager"

# TODO: Parameterize public key
NEW_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/TgYMfiySmr2C6eYGxE2R/Icg8L9/yKwESs7h8cgxNo7HuuBnGD/H59ODD6Rvogyo7KiK9VLDwD9a8flu0DePVMS7gY0Tpe0A8oXzIxO9NbC84Siq4Lly03jJW5QM+e0RaOIPd2u7HJ3lVL3liiNof+JgGVuIFZYDO4VVjjLwnncXlFoK8kJlOKk42z2m0H8Qu8BYdj6kRHwXF7WhXTsdgtfxT99YSRH6c8DG2rgwbHmleYstSZ2SC8QQv4BRC7BR0RrNTJLL1SSfBRKTTm9RDRvsot0B2M5otgzM7GgX6iZBTCZi7uVgXWfrBtyX9dHC1kKB7g1lUs/WIz44ZcgoLiPdNN7f7rs5UgBTqLBLK52xWhr8ez4Zm2FEJ3Hsd5ba4aq581NV/oB60X5faCHvsffvB+QUGstj1bm2U6oPfDDeo70HgPgCZ6V8ceDVJEwHxXZvVoyzsOSiZ9j79y9y6curHKVXnldSI5npuiSyZQv/momLowGADdFykRRNMw+iEcW3XDVo3JFT05yG23C34h+sMY3T64spuksH8gIflopzhhiIfijlvzlBbuSkHRp5B2MzYZo18+b2bdBmwB5lspsMkU+qS/F7LkVq/K4z6pk1J5CYeicqnsfpsPayVew0B1FcTlVLeh89Qx7hoy+m60RGnhKDW10Fn5ZM29oX2w== aroxby@users.noreply.github.com"

for TARGET_USER in $TARGET_USERS; do
    mkdir -p /home/$TARGET_USER/.ssh
    echo "$NEW_KEY" > /home/$TARGET_USER/.ssh/authorized_keys
    chmod 700 /home/$TARGET_USER/.ssh
    chmod 600 /home/$TARGET_USER/.ssh/authorized_keys
    chown -R $TARGET_USER:$TARGET_USER /home/$TARGET_USER
done
