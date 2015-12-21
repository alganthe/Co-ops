/*
 * Author: alganthe
 * Pop a hint with the parsed text passed as argument
 *
 * Arguments:
 * 0: parsed text, can be anything.
 *
 * Return Value:
 * nothing
 */
params ["_parsedText"];

hint parseText format["%1", _parsedText];
