package com.synapse.social.studioasinc.feature.shared.components

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp

@Composable
fun ExpressiveButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    icon: ImageVector? = null,
    text: String,
    variant: ButtonVariant = ButtonVariant.Filled
) {
    when (variant) {
        ButtonVariant.Filled -> Button(
            onClick = onClick,
            modifier = modifier,
            enabled = enabled,
            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp)
        ) {
            ButtonContent(icon, text)
        }

        ButtonVariant.FilledTonal -> FilledTonalButton(
            onClick = onClick,
            modifier = modifier,
            enabled = enabled,
            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp)
        ) {
            ButtonContent(icon, text)
        }

        ButtonVariant.Outlined -> OutlinedButton(
            onClick = onClick,
            modifier = modifier,
            enabled = enabled,
            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp)
        ) {
            ButtonContent(icon, text)
        }

        ButtonVariant.Text -> TextButton(
            onClick = onClick,
            modifier = modifier,
            enabled = enabled,
            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp)
        ) {
            ButtonContent(icon, text)
        }
    }
}

@Composable
private fun ButtonContent(icon: ImageVector?, text: String) {
    icon?.let {
        Icon(
            imageVector = it,
            contentDescription = null,
            modifier = Modifier.size(18.dp)
        )
        Spacer(modifier = Modifier.width(8.dp))
    }
    Text(
        text = text,
        maxLines = 1,
        overflow = TextOverflow.Ellipsis
    )
}

enum class ButtonVariant {
    Filled,
    FilledTonal,
    Outlined,
    Text
}
