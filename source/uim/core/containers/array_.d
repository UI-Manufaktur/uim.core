﻿module uim.core.containers.array_;

import uim.core;

bool has(T)(T[] lhs, T rhs) {
	return lhs.canFind(rhs);
}

// add
T[] add(T)(ref T[] lhs, T rhs) {
	lhs ~= rhs;
	return lhs;
}
T[] add(T)(ref T[] lhs, T[] rhs) {
	 lhs ~= rhs;
	return lhs;
}

// change
void change(T)(ref T left, ref T right) {
	T buffer = left;
	left = right;
	right = buffer;
} 
T[] change(T)(T[] values, size_t left, size_t right) {
	T[] newValues = values.dup;
	T buffer = newValues[left];
	newValues[left] = newValues[right];
	newValues[right] = buffer;
	return newValues;
} 

// sub
T[] sub(T)(ref T[] lhs, T rhs, bool multiple = false) {
	if (multiple) {
		while(lhs.has(rhs)) lhs.sub(rhs);
	}
	else {
		foreach(i, value; lhs) { 
			if (value == rhs) {
				lhs = lhs.remove(i);
				break;
			}
		}
	}
	return lhs;
} 
T[] sub(T)(T[] lhs, T[] rhs, bool multiple = false) {
	foreach(v; rhs) lhs.sub(v, multiple);
	return lhs;
} 

string toJS(T)(T[] values) {
	string result = "[";
	foreach(val; values) result ~= "'%s'".format(val); 
	return result~"]";
}
//T[] sort(T)(T[] values, bool asc = true) {
//	T[] newValues;
//	foreach(v; values) if (v != value) newValues ~= v;
//	return newValues;
//} 

OUT[] castTo(OUT, IN)(IN[] values) {
	OUT[] results; results.length = values.length;
	foreach(i, value; value) result[i] = to!OUT(value);
	return results;
}

unittest {
	writeln("Testing ", __MODULE__);

	auto values = [1, 2, 3, 4]; 
	change(values[2], values[3]); 
	assert(values == [1, 2, 4, 3]);

	assert([1,2,3,4].change(1, 3) == [1, 4, 3, 2]);

	// test add
	values = [1, 2, 3]; assert(values.add(4) == [1,2,3,4]);
	values = [1, 2, 3]; assert(values.add([4,5]) == [1,2,3,4,5]);

	// test sub
	values = [1, 2, 3, 4, 3]; assert(values.sub(3) == [1,2,4,3]);
	values = [1, 2, 3, 4, 3]; assert(values.sub(3, true) == [1,2,4]);
	values = [1, 2, 3, 4, 3]; assert(values.sub([3, 4]) == [1,2,3]);
	values = [1, 2, 3, 4, 3]; assert(values.sub([3, 4], true) == [1,2]);
}