use alexandria_data_structures::array_ext::ArrayTraitExt;
use alexandria_encoding::base64::{
    Base64Encoder, Base64UrlEncoder, Base64FeltEncoder, Base64UrlFeltEncoder
};
use core::debug::PrintTrait;
use core::option::OptionTrait;
use core::traits::TryInto;

fn bytes_be(val: felt252) -> Array<u8> {
    let mut result = array![];

    let mut num: u256 = val.into();
    loop {
        if num == 0 {
            break;
        }
        let (quotient, remainder) = DivRem::div_rem(num, 256_u256.try_into().unwrap());
        result.append(remainder.try_into().unwrap());
        num = quotient;
    };
    loop {
        if result.len() >= 32 {
            break;
        }
        result.append(0_u8);
    };
    result = result.reverse();
    result
}

#[test]
#[available_gas(2000000000)]
fn base64encode_empty_test() {
    let input = 0;
    let result = Base64FeltEncoder::encode(input);
    let check = Base64Encoder::encode(bytes_be(input));
    assert(result == check, 'Expected equal');
}

#[test]
#[available_gas(2000000000)]
fn base64encode_simple_test() {
    let input = 'a';
    let result = Base64FeltEncoder::encode(input);
    let check = Base64Encoder::encode(bytes_be(input));
    assert(result == check, 'Expected equal');
}

#[test]
#[available_gas(2000000000)]
fn base64encode_hello_world_test() {
    let input = 'hello world';
    let result = Base64FeltEncoder::encode(input);
    let check = Base64Encoder::encode(bytes_be(input));
    assert(result == check, 'Expected equal');
}


#[test]
#[available_gas(2000000000)]
fn base64encode_with_plus_and_slash() {
    let mut input = 65519; // Equivalent to array![255, 239] as bytes_be

    let result = Base64FeltEncoder::encode(input);
    let check = Base64Encoder::encode(bytes_be(input));
    assert(result == check, 'Expected equal');
}

#[test]
#[available_gas(2000000000)]
fn base64urlencode_with_plus_and_slash() {
    let mut input = 65519; // Equivalent to array![255, 239] as bytes_be

    let result = Base64UrlFeltEncoder::encode(input);
    let check = Base64UrlEncoder::encode(bytes_be(input));
    assert(result == check, 'Expected equal');
}
